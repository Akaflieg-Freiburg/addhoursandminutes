<!--
Saved implementation plan, written 2026-08-11. Not yet implemented.
Blocked on three manual prerequisites (Developer ID certificate, notarytool
credentials, Sparkle EdDSA key pair) — see the Prerequisites section below.
-->

# Sparkle auto-updates for the macOS direct-download build

## Context

"Add Times" ships on macOS only through the Mac App Store (`fastlane mac TestFlight`).
There is no direct-download build for end users — the only `.dmg` that exists is the
unsigned, un-notarized developer build that `.github/workflows/macos.yml` pushes to the
rolling `developerBuilds` GitHub release, and it is not linked from the homepage.

The goal is a second, self-updating macOS distribution channel: a Developer-ID-signed,
notarized universal build that carries the [Sparkle](https://sparkle-project.org)
framework, checks a GitHub-hosted appcast, and updates itself. Binaries and the appcast
both live on GitHub Releases. The App Store build stays exactly as it is — Apple forbids
third-party updaters in sandboxed MAS apps, so Sparkle must be compile-time optional and
**off by default**.

Decisions already taken:

| Question | Decision |
|---|---|
| Appcast hosting | GitHub release asset on a fixed `appcast` tag |
| Package format | DMG for first install, ZIP for Sparkle updates |
| Background checks | Sparkle's default first-launch permission prompt |
| Install mode | Ask once, then remember (Sparkle default — set no override keys) |
| "Check for updates…" menu item | Yes, macOS-only |
| Where releases are built | Local `fastlane mac release` lane, no CI secrets |

---

## Prerequisites (manual, one-time — do these first)

These are blocking; nothing else can be verified end-to-end without them.

1. **Developer ID Application certificate.** `security find-identity -v -p codesigning`
   currently lists only *Apple Development* and *Apple Distribution*. A
   `Developer ID Application: Akademische Fliegergruppe Freiburg i. Br. e. V. (9DX97T4PBT)`
   certificate must be created at developer.apple.com → Certificates. Only the team's
   **Account Holder** can create it, and a team is limited to 5. Export the private key
   as `.p12` and back it up offline.

2. **Notarization credentials.** Create an App Store Connect API key (Developer role is
   enough) and store a notarytool profile once:
   ```
   xcrun notarytool store-credentials "AddTimes-Notary" \
     --key ~/.appstoreconnect/private_keys/AuthKey_XXXX.p8 --key-id XXXX --issuer <uuid>
   ```
   Later steps refer to it as `--keychain-profile "AddTimes-Notary"`.

3. **Sparkle tools and EdDSA key pair.** Download the Sparkle 2.x binary release tarball
   (`Sparkle-2.x.y.tar.xz`) — it contains the universal `Sparkle.framework` plus
   `bin/generate_keys`, `bin/sign_update`, `bin/generate_appcast`. Run `./bin/generate_keys`
   once; it prints the **public** key (goes into `Info.plist` as `SUPublicEDKey`) and stores
   the private key in the login keychain.
   **Export and back up the private key** (`./bin/generate_keys -x sparkle_private_key.txt`,
   then store offline and delete the file). Losing it means no already-installed copy can
   ever be updated again.

---

## Part 1 — CMake: fetch, compile against, and embed Sparkle

### 1.1 Top-level `CMakeLists.txt`

Add next to the existing `QTDEPLOY` option:

```cmake
option(WITH_SPARKLE "Embed the Sparkle auto-update framework (macOS direct-download builds only)" OFF)
```

and after `project(...)`:

```cmake
if (APPLE AND WITH_SPARKLE)
    enable_language(OBJCXX)
endif()
```

`enable_language(OBJCXX)` is genuinely required: the iOS `.mm` file compiles today only
because iOS uses the Xcode generator, whereas macOS builds use Ninja
([Fastfile:202](/fastlane/Fastfile#L202)) and would silently ignore an `.mm` source.

Fetch the prebuilt framework, gated so that no other platform's configure step ever
touches the network (important — the flatpak build must stay offline):

```cmake
if (CMAKE_SYSTEM_NAME STREQUAL "Darwin" AND WITH_SPARKLE)
    include(FetchContent)
    FetchContent_Declare(Sparkle
        URL      https://github.com/sparkle-project/Sparkle/releases/download/2.8.0/Sparkle-2.8.0.tar.xz
        URL_HASH SHA256=<pin the published checksum>
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        SOURCE_SUBDIR  no-cmake-project-here   # tarball has no CMakeLists.txt
    )
    FetchContent_MakeAvailable(Sparkle)
    set(SPARKLE_FRAMEWORK "${sparkle_SOURCE_DIR}/Sparkle.framework")
endif()
```

Pin the newest Sparkle 2.x tag and its real SHA256 at implementation time. This is the
repo's **first** external dependency — there is no `FetchContent`, `ExternalProject`,
submodule or vcpkg usage anywhere today, so there is no existing pattern to match.

### 1.2 `src/CMakeLists.txt` — the Darwin block ([src/CMakeLists.txt:112-130](/src/CMakeLists.txt#L112-L130))

Inside the existing `if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")`, add a `WITH_SPARKLE`
sub-block:

```cmake
if (WITH_SPARKLE)
    target_sources(${PROJECT_NAME} PRIVATE macos/SparkleAdapter.mm macos/SparkleAdapter.h)
    target_compile_definitions(${PROJECT_NAME} PRIVATE WITH_SPARKLE)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${SPARKLE_FRAMEWORK} "-framework AppKit")
    set_target_properties(${PROJECT_NAME} PROPERTIES
        INSTALL_RPATH "@executable_path/../Frameworks"
        BUILD_WITH_INSTALL_RPATH TRUE)

    # Embed the framework. Use ditto, not `cmake -E copy_directory`: the latter may
    # dereference the symlinks that make up the framework's Versions/ layout.
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory
                "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Frameworks"
        COMMAND ditto "${SPARKLE_FRAMEWORK}"
                "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Frameworks/Sparkle.framework"
        VERBATIM)
endif()
```

Passing the full `.framework` path to `target_link_libraries` makes CMake emit
`-F<dir> -framework Sparkle`, so `#import <Sparkle/Sparkle.h>` resolves.

**Ordering matters.** `qt_generate_deploy_qml_app_script(... MACOS_BUNDLE_POST_BUILD)`
([src/CMakeLists.txt:164-169](/src/CMakeLists.txt#L164-L169)) registers its own post-build
step later in the file and at target finalization, so it runs *after* the `ditto` above —
which is what we want: `macdeployqt` sees a bundle that already contains
`Sparkle.framework` and can resolve `@rpath/Sparkle.framework/Versions/B/Sparkle`.
Verify this during implementation; if `macdeployqt` reports an unresolvable dependency,
the copy is running too late.

**Verify during implementation:** that `install(TARGETS ... BUNDLE DESTINATION .)`
([src/CMakeLists.txt:173-177](/src/CMakeLists.txt#L173-L177)) carries the embedded
framework into `build/addhoursandminutes.app` with its symlinks intact
(`ls -l build/addhoursandminutes.app/Contents/Frameworks/Sparkle.framework`). If CMake
flattens the symlinks, add an explicit `install(CODE "execute_process(COMMAND ditto ...)")`
after the deploy-script install instead.

### 1.3 Version numbers and `Info.plist`

The generated plist today has `CFBundleShortVersionString = 1.5` (CMake's `major.minor`
default) while `CFBundleVersion = 1.5.0`. Sparkle *displays* the short string, so patch
releases would be indistinguishable. Fix by setting both explicitly in the
`set_target_properties` call — using `${PROJECT_VERSION}` for both keeps `CFBundleVersion`
byte-identical to what App Store Connect has already accepted, so the MAS pipeline is
untouched:

```cmake
MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
MACOSX_BUNDLE_BUNDLE_VERSION       ${PROJECT_VERSION}
```

Turn [src/macos/Info.plist](/src/macos/Info.plist) into a template
`src/macos/Info.plist.in` so the Sparkle keys appear only in Sparkle builds — mirroring
the `AndroidManifest.xml.in` pattern already used at
[src/CMakeLists.txt:91](/src/CMakeLists.txt#L91):

```cmake
if (WITH_SPARKLE)
    set(SPARKLE_PLIST_ENTRIES
"\t<key>SUFeedURL</key>\n\t<string>${SPARKLE_FEED_URL}</string>\n\t<key>SUPublicEDKey</key>\n\t<string>${SPARKLE_PUBLIC_ED_KEY}</string>")
else()
    set(SPARKLE_PLIST_ENTRIES "")
endif()
configure_file(macos/Info.plist.in "${CMAKE_CURRENT_BINARY_DIR}/Info.plist" @ONLY)
```

then point `MACOSX_BUNDLE_INFO_PLIST` at `${CMAKE_CURRENT_BINARY_DIR}/Info.plist`. Use
`@ONLY` so the `${MACOSX_BUNDLE_*}` placeholders survive for CMake's own substitution
pass; the new entries use `@SPARKLE_PLIST_ENTRIES@`.

While editing the template, also fix `LSMinimumSystemVersion`, which still says `10.13`
although release builds pass `-DCMAKE_OSX_DEPLOYMENT_TARGET=14.0`.

Deliberately **do not** set `SUEnableAutomaticChecks` or `SUAutomaticallyUpdate` — their
absence is exactly the chosen behaviour (first-launch permission prompt, and the update
dialog's "install automatically in future" checkbox).

### 1.4 Non-sandboxed entitlements

New file `src/macos/addhoursandminutes_developerID.entitlements` — the existing
[src/macos/addhoursandminutes.entitlements](/src/macos/addhoursandminutes.entitlements)
is MAS-specific (`com.apple.application-identifier`, sandbox) and cannot be reused:

```xml
<dict>
    <key>com.apple.security.cs.allow-jit</key><true/>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key><true/>
</dict>
```

No sandbox, no application-identifier, no provisioning profile. The two JIT entitlements
are there because the build is universal and Qt's QML V4 JIT allocates W+X memory on
x86_64, which the hardened runtime otherwise kills at launch. Sparkle itself needs no
entitlements in a non-sandboxed app (its XPC services are only for sandboxed hosts).

---

## Part 2 — The C++/ObjC++ shim and the QML menu item

### 2.1 `src/macos/SparkleAdapter.{h,mm}`

Follow the existing [src/ios/ObjCAdapter.h](/src/ios/ObjCAdapter.h) pattern exactly: a
pure-C++ header with only static methods (no Objective-C types leak out), implemented in
a `.mm`.

```cpp
// SparkleAdapter.h
#pragma once
class SparkleAdapter {
public:
    static void startUpdater();     // create + start the SPUStandardUpdaterController
    static void checkForUpdates();  // user-initiated check
};
```

The `.mm` keeps a file-static `SPUStandardUpdaterController *` (Sparkle requires the
controller to be retained for the app's lifetime) created with `startingUpdater:YES`,
`updaterDelegate:nil`, `userDriverDelegate:nil`. `checkForUpdates()` forwards to
`[updaterController checkForUpdates:nil]`.

### 2.2 `src/main.cpp`

Call `SparkleAdapter::startUpdater()` after the `QGuiApplication` is constructed and
before `engine.load(...)`, guarded by `#if defined(Q_OS_MACOS) && defined(WITH_SPARKLE)`.
It must run at startup, not on menu click — otherwise no scheduled checks and no
first-launch prompt. This slots in next to the two existing platform `#if` blocks
(`Q_OS_WINDOWS` style, `Q_OS_ANDROID` splash screen).

### 2.3 `src/platformAdapter.{h,cpp}`

Extend the existing `QML_SINGLETON`:

```cpp
Q_PROPERTY(bool updatesSupported READ updatesSupported CONSTANT)
[[nodiscard]] bool updatesSupported() const;   // true only when WITH_SPARKLE
public slots:
    static void checkForUpdates();
```

`checkForUpdates()` dispatches under `#if defined(Q_OS_MACOS) && defined(WITH_SPARKLE)`
and is a no-op otherwise — same shape as the existing `vibrateBrief()`/`vibrateError()`.
Note the existing API is all-static; `updatesSupported` should be a normal const member
function so the `Q_PROPERTY` is idiomatic.

### 2.4 `src/qml/main.qml`

Add a third item to `mainMenu` ([main.qml:82-112](/src/qml/main.qml#L82-L112)):

```qml
MenuItem {
    icon.source: "/images/ic_update_24px.svg"
    text: qsTr("Check for Updates…")
    visible: PlatformAdapter.updatesSupported
    height: visible ? implicitHeight : 0   // Menu's ListView still reserves space otherwise
    onTriggered: PlatformAdapter.checkForUpdates()
}
```

The `height` binding is not optional — an invisible `MenuItem` still occupies a row in
Qt Quick Controls' `Menu`, which would leave a gap on every non-macOS platform.

Supporting changes:
- New `src/images/ic_update_24px.svg` (Material `system_update_alt`), added to the
  `qt_add_resources(${PROJECT_NAME} "imageresources" ...)` list at
  [src/CMakeLists.txt:30-36](/src/CMakeLists.txt#L30-L36).
- Run the `update_translations` target and add the German string to
  `src/addhoursandminutes_de.ts`; the other four (`es fr it pl`) can stay untranslated.
- Add a Sparkle attribution line to the About dialog text
  ([main.qml:160-201](/src/qml/main.qml#L160-L201)) and to
  [docs/_pages/acknowledgements.markdown](/docs/_pages/acknowledgements.markdown) —
  Sparkle is MIT-licensed (GPL-3-compatible) but the licence requires the copyright
  notice to be reproduced.

---

## Part 3 — fastlane

### 3.1 Parameterise `mac build`

Change `lane :build` ([Fastfile:194](/fastlane/Fastfile#L194)) to accept
`|options|`, and when `options[:sparkle]` is set, append `-DWITH_SPARKLE=ON` and use a
**separate build directory** (`build/build-macos-release-sparkle`) so the MAS and
direct-download configurations never share a CMake cache. The existing behaviour with no
options must stay bit-for-bit identical, so `mac TestFlight` is unaffected.

### 3.2 New lane `mac release`

Produces signed, notarized, stapled artifacts in `build/`; uploads nothing.

1. `build(sparkle: true)`, then `xattr -cr` the bundle (same hygiene step the TestFlight
   lane already does).
2. **Sign inside-out.** Do *not* use `--deep`, which the existing TestFlight lane relies
   on ([Fastfile:231](/fastlane/Fastfile#L231)) — it signs nested bundles with the host's
   entitlements and mis-handles Sparkle's helpers. Sign in this order, each with
   `--force --options runtime --timestamp --sign "Developer ID Application: …(9DX97T4PBT)"`:
   1. `Contents/Frameworks/Sparkle.framework/Versions/B/XPCServices/*.xpc` (if present)
   2. `…/Versions/B/Autoupdate` and `…/Versions/B/Updater.app`
   3. `…/Frameworks/Sparkle.framework`
   4. every Qt framework and plugin under `Contents/Frameworks` and `Contents/PlugIns`
      (`macdeployqt` ad-hoc-signs them, so they must be re-signed *after* deployment)
   5. the `.app` itself, with `--entitlements ../src/macos/addhoursandminutes_developerID.entitlements`
3. Verify: `codesign --verify --deep --strict --verbose=2 build/addhoursandminutes.app`.
4. **Notarize the app.** `ditto -c -k --sequesterRsrc --keepParent` the `.app` into a
   temporary zip (plain `zip` would destroy the framework symlinks), submit with
   `xcrun notarytool submit … --keychain-profile "AddTimes-Notary" --wait`, then
   `xcrun stapler staple build/addhoursandminutes.app`.
5. **Final ZIP for Sparkle** — re-run `ditto -c -k --sequesterRsrc --keepParent` on the
   now-stapled app → `build/addTimes-macOS-universal.zip`.
6. **DMG for first install** — stage the stapled `.app` plus an `/Applications` symlink,
   `hdiutil create -volname "Add Times" -format UDZO -ov`, `codesign --timestamp` the
   DMG, notarize it (second submission), `xcrun stapler staple` it →
   `build/addTimes-macOS-universal.dmg`.
7. `spctl -a -vvv -t exec` on the app must report `source=Notarized Developer ID`.

### 3.3 Appcast generation and upload

Create the stable feed location once, by hand:
```
gh release create appcast --title "Sparkle appcast" --notes "Update feed for the macOS build."
```
giving the permanent `SUFeedURL`
`https://github.com/Akaflieg-Freiburg/addhoursandminutes/releases/download/appcast/appcast.xml`.
(Prefer this over `releases/latest/download/…`, which breaks whenever a release ships
without the asset attached.)

Extend `gitHubRelease` ([Fastfile:246](/fastlane/Fastfile#L246)) with a macOS step, run
only when `FastlaneCore::Helper.mac?`:

1. Invoke `mac release`.
2. `gh release upload v<version>` the `.dmg` and `.zip` alongside the existing APK/AAB.
3. Compute the Sparkle signature: `sign_update build/addTimes-macOS-universal.zip`
   returns `sparkle:edSignature="…" length="…"` ready to paste into the item.
4. Download the current feed (`gh release download appcast -p appcast.xml`, tolerate
   failure on the very first run), splice a new `<item>` in **before** the existing ones,
   and re-upload with `gh release upload appcast appcast.xml --clobber`. Keeping the old
   items means a user several versions behind sees the full history of release notes.

The item to prepend, built from the existing `latest_changelog_entry` helper
([Fastfile:7-18](/fastlane/Fastfile#L7-L18)):

```xml
<item>
  <title>Version 1.5.1</title>
  <pubDate>…RFC 822…</pubDate>
  <sparkle:version>1.5.1</sparkle:version>
  <sparkle:shortVersionString>1.5.1</sparkle:shortVersionString>
  <sparkle:minimumSystemVersion>14.0</sparkle:minimumSystemVersion>
  <description><![CDATA[<ul><li>…</li></ul>]]></description>
  <enclosure url="https://github.com/Akaflieg-Freiburg/addhoursandminutes/releases/download/v1.5.1/addTimes-macOS-universal.zip"
             sparkle:edSignature="…" length="…" type="application/octet-stream"/>
</item>
```

`sparkle:version` must equal `CFBundleVersion` exactly, which §1.3 pins to
`${PROJECT_VERSION}`. `latest_changelog_entry` returns Markdown; the changelog entries are
uniformly `- ` bullet lists, so a ten-line Ruby converter to `<ul><li>` inside the CDATA
is sufficient — no Markdown gem dependency needed.

Note the `mac` lanes only run on macOS, so on Linux `gitHubRelease` keeps its current
Android-only behaviour.

### 3.4 Documentation

- [CLAUDE.md](/CLAUDE.md): add `WITH_SPARKLE` to the build-requirements section, document
  the `mac release` lane and the notarytool profile name, note the two distinct macOS
  channels, and record that the Sparkle EdDSA private key lives in the login keychain.

  (`fastlane/README.md` is fastlane's auto-generated file and is gitignored — nothing
  written there survives, so all of this goes into `CLAUDE.md`.)

---

## Part 4 — Homepage

- [docs/_pages/download.markdown](/docs/_pages/download.markdown): add a "macOS Desktop"
  section linking
  `https://github.com/Akaflieg-Freiburg/addhoursandminutes/releases/latest/download/addTimes-macOS-universal.dmg`,
  with one sentence explaining that this build updates itself while the App Store version
  updates through the App Store.
- [docs/_pages/privacy.markdown](/docs/_pages/privacy.markdown): one sentence that the
  direct-download macOS build contacts GitHub to check for updates, and that GitHub sees
  the IP address. (Not strictly required given the opt-in prompt, but cheap and correct.)

Both files live under `docs/`, which GitHub Pages serves from `main` — so these land with
the release merge, not on `develop`.

`.github/workflows/macos.yml` needs **no change**: `WITH_SPARKLE` defaults to `OFF`, so CI
keeps producing the same unsigned Sparkle-free developer DMG.

---

## Risks and things that will bite

1. **The Sparkle EdDSA private key is unrecoverable.** No backup ⇒ every installed copy is
   permanently stuck. Back it up before the first release, not after.
2. **First release is a one-way door for existing users only in one direction.** Sparkle
   can only update copies that already contain Sparkle. Whoever has today's MAS build or a
   `developerBuilds` DMG will never be offered an update; they have to download once by
   hand. Worth saying so on the download page.
3. **`--deep` signing.** The habit from the TestFlight lane will silently produce a bundle
   that fails notarization or breaks the updater. Use the ordered sequence.
4. **Sign after `macdeployqt`, never before.** Qt's deploy step rewrites load commands and
   ad-hoc re-signs, invalidating any earlier signature.
5. **Same bundle ID for both channels** (`de.akafliegfreiburg.addhoursandminutes`). Keep it
   — it preserves `QSettings` state and window geometry across a switch — but be aware a
   user could end up with an MAS copy and a direct copy side by side.
6. **Universal framework.** Confirm with `lipo -archs Sparkle.framework/Versions/B/Sparkle`
   that the fetched binary really is `x86_64 arm64`; a thin framework silently breaks the
   `CMAKE_OSX_ARCHITECTURES=x86_64;arm64` link.
7. **GitHub release-asset caching.** The appcast may be served slightly stale for a few
   minutes after `--clobber`. Harmless, but expect it when testing.
8. Deployment target 14.0 comfortably exceeds Sparkle 2.x's 10.13 minimum.

---

## Verification

**Build sanity (no signing needed).**
```
$Qt6_DIR_MACOS/bin/qt-cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DWITH_SPARKLE=ON \
  -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" -DCMAKE_OSX_DEPLOYMENT_TARGET=14.0 \
  -DCMAKE_INSTALL_PREFIX=../build/ -DQTDEPLOY=ON -S .. -B ../build/build-macos-release-sparkle
cmake --build … && cmake --build … --target install
otool -L build/addhoursandminutes.app/Contents/MacOS/addhoursandminutes | grep Sparkle
ls -l  build/addhoursandminutes.app/Contents/Frameworks/Sparkle.framework   # symlinks intact
plutil -p build/addhoursandminutes.app/Contents/Info.plist | grep -E 'SU|Version'
```
Launch it: the permission prompt appears on first run, and "Check for Updates…" is in the
hamburger menu.

**MAS path is untouched.** `fastlane mac build` (no `sparkle:` option) must produce a
bundle with *no* `Sparkle.framework` and *no* `SU*` keys in `Info.plist`;
`fastlane mac TestFlight` must still validate.

**End-to-end update test** — the only way to know the appcast is right:
1. Build and install version `9.9.8` with `WITH_SPARKLE=ON` into `/Applications`.
2. Build `9.9.9`, zip and `sign_update` it, write a local `appcast.xml` next to it,
   serve with `python3 -m http.server`.
3. Point the installed copy at it:
   `defaults write de.akafliegfreiburg.addhoursandminutes SUFeedURL http://localhost:8000/appcast.xml`
4. Launch 9.9.8, trigger "Check for Updates…", confirm the release notes render, the
   update downloads, installs and relaunches as 9.9.9.
5. `defaults delete de.akafliegfreiburg.addhoursandminutes SUFeedURL` afterwards.

**Signing and notarization.**
```
codesign --verify --deep --strict --verbose=2 build/addhoursandminutes.app
spctl -a -vvv -t exec build/addhoursandminutes.app     # → source=Notarized Developer ID
xcrun stapler validate build/addhoursandminutes.app
xcrun stapler validate build/addTimes-macOS-universal.dmg
```
Best final check: copy the DMG to a Mac that has never seen the app (or clear the
quarantine cache), install from it, and confirm it opens without a Gatekeeper warning.

---

## Files touched

| File | Change |
|---|---|
| `CMakeLists.txt` | `WITH_SPARKLE` option, `enable_language(OBJCXX)`, `FetchContent` of Sparkle |
| `src/CMakeLists.txt` | Sparkle sources/link/rpath/embed, explicit bundle versions, `Info.plist.in`, new icon resource |
| `src/macos/Info.plist` → `Info.plist.in` | `@SPARKLE_PLIST_ENTRIES@`, corrected `LSMinimumSystemVersion` |
| `src/macos/addhoursandminutes_developerID.entitlements` | new — non-sandboxed, JIT allowances |
| `src/macos/SparkleAdapter.{h,mm}` | new — retained `SPUStandardUpdaterController` |
| `src/main.cpp` | start the updater on macOS Sparkle builds |
| `src/platformAdapter.{h,cpp}` | `updatesSupported` property + `checkForUpdates()` slot |
| `src/qml/main.qml` | menu item, About-dialog attribution |
| `src/images/ic_update_24px.svg` | new icon |
| `src/addhoursandminutes_de.ts` | new string |
| `fastlane/Fastfile` | `mac build` gains `sparkle:`, new `mac release`, `gitHubRelease` uploads macOS artifacts + appcast |
| `CLAUDE.md` | document the new channel (`fastlane/README.md` is gitignored) |
| `docs/_pages/download.markdown`, `docs/_pages/privacy.markdown`, `docs/_pages/acknowledgements.markdown` | macOS download, update-check note, Sparkle licence |
