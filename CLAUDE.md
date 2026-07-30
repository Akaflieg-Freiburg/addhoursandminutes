# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

"Add Times" (`addhoursandminutes`) is a small Qt 6/QML calculator app that adds times given in hours and minutes. GPL-3.0+, published by Akaflieg Freiburg on Google Play, the Apple App Store, Flathub, and as a WebAssembly build on the project homepage. App ID is `de.akaflieg_freiburg.cavok.add_hours_and_minutes` (Apple platforms use `de.akafliegfreiburg.addhoursandminutes`).

There is no test suite and no linter configuration; verification means building and running the app.

## Build requirements

- CMake ≥ 3.19, C++20, Qt ≥ 6.9 (Qt 6.8.1 and 6.8.3 are explicitly rejected in `src/CMakeLists.txt`).
- Builds always go through the `qt-cmake` wrapper of a per-platform Qt kit, located via environment variables: `Qt6_DIR_LINUX`, `Qt6_DIR_ANDROID`, `Qt6_DIR_MACOS`, `Qt6_DIR_WASM` (plus `ANDROID_SDK_ROOT`, `ANDROID_NDK_ROOT`, and `QT_ANDROID_KEYSTORE_*` variables for signed Android builds).
- Android: `ANDROID_PLATFORM` must be `android-28` (enforced with FATAL_ERROR); the fastlane lane appends `_x86_64` to `Qt6_DIR_ANDROID` to find the host qt-cmake and builds all ABIs.

## Common commands

```bash
# Linux debug build with clang + sanitizers (run from repo root; output in build-linux-debug/)
./buildscript-linux-debug.sh

# Release builds via fastlane (run from repo root; artifacts land in build/)
fastlane android build      # signed APK + AAB: build/addhoursandminutes.{apk,aab}
fastlane linux build
fastlane mac build          # macOS only

# Store deployment
fastlane android validate            # dry-run upload to Google Play
fastlane android deployBeta          # upload AAB to Play beta track
fastlane android promoteBetaToRelease
fastlane mac TestFlight              # macOS only; signs, packages, uploads

# WebAssembly
./buildscript-webasm.sh     # build
./run-webasm.sh             # build + serve locally
./publish-webasm.sh         # build, copy into docs/assets/webasm/, and git commit

# Releases
fastlane gitHubRelease      # builds Android, creates GitHub release with APK/AAB via gh
fastlane flathubRelease     # generates flatpak manifest, opens PR against the flathub repo
```

## Versioning and releases

- The single source of truth for the version is `project(addhoursandminutes VERSION x.y.z)` in the top-level `CMakeLists.txt`. The Android `versionCode` is computed as `100000*major + 1000*minor + patch` — this formula is duplicated in `fastlane/Fastfile` (helper `latest_changelog_entry`); keep them in sync.
- `CHANGELOG.md` is machine-parsed by fastlane lanes (`## <version> - <date>` headings). The latest entry becomes the Play Store changelog (`fastlane android metadata` writes `fastlane/metadata/android/en-US/<versionCode>.txt`) and the GitHub release notes.
- Play Store listing texts live in `fastlane/metadata/android/{en-US,de-DE}/`; AppStream/desktop metadata in `metadata/`.

## Architecture

The app is a single Qt Quick executable with almost all logic in QML:

- `src/main.cpp` — sets up `QGuiApplication`, installs translators (`.ts` files in `src/`, languages: de es fr it pl), picks a Qt Quick style per platform, loads the QML module.
- `src/qml/` — the QML module (URI `gui`, registered in `src/CMakeLists.txt`). `main.qml` is the entry point; the calculator logic lives in `Calculator.qml`/`Keypad.qml`.
- `src/platformAdapter.{h,cpp}` — the only C++/QML bridge, a `QML_SINGLETON` exposing `vibrateBrief()`/`vibrateError()`. It dispatches per platform: on Android via JNI (`QJniObject`) to the Java class `AndroidAdaptor`, on iOS to `src/ios/ObjCAdapter.mm`, no-op on desktop.
- `src/android/src/.../AndroidAdaptor.java` — extends Qt's `QtActivity`; provides the vibration methods called via JNI. Class/package names here must match the JNI strings in `platformAdapter.cpp` and the activity name in the manifest template.

### Android packaging specifics

- `src/AndroidManifest.xml.in` is processed by `configure_file` and used via `QT_ANDROID_PACKAGE_SOURCE_DIR` (a copy in the build dir, assembled from `src/android/` plus generated icons).
- Package name, version, and SDK levels are NOT set in the manifest — they flow through Qt CMake target properties in `src/CMakeLists.txt` (`QT_ANDROID_PACKAGE_NAME`, `QT_ANDROID_VERSION_NAME/CODE`, `QT_ANDROID_MIN/TARGET_SDK_VERSION`). The manifest's `android:versionName`/`android:versionCode` attributes must keep the androiddeployqt placeholder strings (`-- %%INSERT_VERSION_NAME%% --`), which get substituted at package time; androiddeployqt only replaces placeholders, it never adds missing attributes.
- Do not reintroduce a `<uses-sdk>` element or a `package=` attribute into the manifest template: the Android Gradle Plugin shipped with Qt ≥ 6.11 (AGP 9) fails the build on `<uses-sdk>` and ignores `package=`.

### Other directories

- `generatedSources/` — committed build artifacts (PNG icons rendered from the SVGs in `metadata/`, Play Store feature graphics). Regenerate with the `generatedSources` CMake target (needs `rsvg-convert` and ImageMagick); don't edit the PNGs by hand.
- `packaging/flatpak/` — flatpak manifest template, configured by CMake into the build dir.
- `docs/` — Jekyll-based GitHub Pages homepage; `docs/assets/webasm/` holds the deployed WebAssembly build (updated only via `publish-webasm.sh`).

## Git conventions

Day-to-day work happens on `develop`; `main` is the release branch. GitHub Actions compile the app per platform (android/ios/linux/macos/windows workflows) on every push to `develop`.
