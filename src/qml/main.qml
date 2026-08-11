/***************************************************************************
 *   Copyright (C) 2018 - 2025 by Stefan Kebekus                           *
 *   stefan.kebekus@math.uni-freiburg.de                                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import gui

ApplicationWindow {
    id: window

    // Desktop platforms get a menu bar, and the burger button in the tool bar is
    // hidden there. Everywhere else it is the other way round. Note that Qt 6
    // reports macOS as "osx" and not as "macos".
    readonly property bool isMacOS: Qt.platform.os === "osx"
    readonly property bool hasMenuBar: isMacOS
                                       || (Qt.platform.os === "linux")
                                       || (Qt.platform.os === "windows")

    // Height that the menu bar takes away from the window content. Zero on macOS,
    // where the menu bar is a native one that lives outside of the window, and on
    // the platforms where there is no menu bar at all.
    readonly property real menuBarHeight: mainMenuBar.visible ? mainMenuBar.height : 0

    // An explicit binding rather than Material.System: only explicitly themed
    // Material objects register for system color scheme updates, so with the
    // System default from qtquickcontrols2.conf, existing menus and dialogs
    // would keep their colors when the scheme changes while the app runs.
    Material.theme: Style.isDark ? Material.Dark : Material.Light

    width: toolBar.font.pixelSize*15*1.5
    height: toolBar.font.pixelSize*20*1.5 + menuBarHeight
    minimumWidth: toolBar.font.pixelSize*12*1.5
    minimumHeight: toolBar.font.pixelSize*14*1.5 + menuBarHeight

    Settings {
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
    }

    flags: (Qt.platform.os === "ios") ? Qt.ExpandedClientAreaHint : Qt.Window

    title: qsTr("Add Times")

    color: Style.display
    // ApplicationWindow paints a styled background item on top of the window
    // color; without this override the two would disagree in dark mode.
    background: Rectangle { color: Style.display }

    visible: true

    // Menu bar for desktop computers. On macOS this becomes the native menu bar
    // in the system menu. Qt moves the items whose text begins with "About" or
    // "Quit" into the application menu there, and hides the menus that are left
    // empty afterwards - so the "File" menu below shows up on Linux and Windows
    // only, and needs no explicit platform check of its own.
    menuBar: MenuBar {
        id: mainMenuBar

        visible: window.hasMenuBar

        // Colored like the menus that drop out of it, for the same reasons as
        // the burger menu further below. Palette-based styles use the palette,
        // the Material style uses Material.background.
        Material.background: Style.popupWindow
        palette {
            window: Style.popupWindow
            windowText: Style.popupWindowText
            text: Style.popupText
            base: Style.popupWindow
            // Palette-based styles paint the menu bar in the button color. Use
            // the popup background instead, so that the bar reads as a menu
            // surface rather than as a strip of buttons.
            button: Style.popupWindow
            buttonText: Style.popupButtonText
            mid: Style.popupMid
            dark: Style.popupDark
        }

        Menu {
            title: qsTr("File")

            Material.background: Style.popupWindow
            palette {
                window: Style.popupWindow
                windowText: Style.popupWindowText
                text: Style.popupText
                base: Style.popupWindow
                button: Style.popupButton
                buttonText: Style.popupButtonText
                mid: Style.popupMid
                dark: Style.popupDark
            }

            Action {
                // On macOS this item is moved into the application menu, where
                // the platform substitutes its own localized "Quit <app>" for
                // the text below. Qt recognizes the item by its wording, and
                // only the untranslated English one is matched in every locale
                // - so the text is deliberately not translated there.
                text: window.isMacOS ? "Quit" : qsTr("Quit")
                shortcut: StandardKey.Quit
                onTriggered: Qt.quit()
            }
        }

        // AppKit adds its search field to the menu titled "Help", provided that
        // the title matches its own translation of that word.
        Menu {
            title: qsTr("Help")

            Material.background: Style.popupWindow
            palette {
                window: Style.popupWindow
                windowText: Style.popupWindowText
                text: Style.popupText
                base: Style.popupWindow
                button: Style.popupButton
                buttonText: Style.popupButtonText
                mid: Style.popupMid
                dark: Style.popupDark
            }

            Action {
                text: qsTr("Help")
                onTriggered: helpDialog.open()
            }

            // No separator above this item: on macOS the item moves into the
            // application menu, and a separator would be left dangling.
            Action {
                // Untranslated on macOS for the same reason as "Quit" above.
                text: window.isMacOS ? "About" : qsTr("About")
                onTriggered: infoDialog.open()
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        ToolBar {
            id: toolBar

            Layout.fillWidth: true
            background: Rectangle {
                color: Style.teal
                // The tool bar is empty where the menu bar takes over, and its
                // height comes from the burger button alone. Without an implicit
                // height of its own, the teal band would collapse there.
                implicitHeight: toolButton.implicitHeight
            }

            RowLayout {
                anchors.fill: parent

                ToolButton {
                    id: toolButton

                    visible: !window.hasMenuBar

                    background: Rectangle { color: Style.teal }

                    icon.source: "/images/ic_menu_24px.svg"
                    icon.color: Style.tealText

                    Accessible.name: qsTr("Menu")

                    onClicked: mainMenu.open()

                    Menu {
                        id: mainMenu

                        // Qt does not push a system color scheme change into
                        // existing popups; these bindings keep the menu colors
                        // current. Palette-based styles use the palette, the
                        // Material style uses Material.background.
                        Material.background: Style.popupWindow
                        palette {
                            window: Style.popupWindow
                            windowText: Style.popupWindowText
                            text: Style.popupText
                            base: Style.popupWindow
                            button: Style.popupButton
                            buttonText: Style.popupButtonText
                            mid: Style.popupMid
                            dark: Style.popupDark
                        }

                        MenuItem {
                            icon.source: "/images/ic_help_24px.svg"
                            text: qsTr("Help")
                            onTriggered: helpDialog.open()
                        }

                        MenuItem {
                            icon.source: "/images/ic_info_24px.svg"
                            text: qsTr("About")
                            onTriggered: infoDialog.open()
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

            }
        }

        Calculator {
            id: calculator

            Layout.fillHeight: true
            Layout.fillWidth: true
            focus: true
        }
    }

    LongTextDialog {
        id: helpDialog

        // qmllint disable
        title: qsTr("Help")
        text: qsTr("
<h4>Enter Times</h4>

<p>In order to enter the time <strong>1 hour and 23 minutes</strong>, simply press the keys
<strong>1</strong>, <strong>2</strong> and <strong>3</strong>.</p>

<h4>Reset</h4>

<p>To reset the calculator, press and hold the <strong>C</strong> key.</p>

<h4>Resize</h4>

<p>Drag the dividing line above the keypad to change the keypad size.</p>
")
        // qmllint enable

        standardButtons: DialogButtonBox.Ok
    }

    LongTextDialog {
        id: infoDialog

        // qmllint disable
        title: qsTr("Add Times")
        text: qsTr("
<h4>Version %1</h4>

<p>This is a simple calculator app that adds times given in hours and minutes.
  It helps you record machine running times, add up the flight times in your
  pilot logbook, or track your driving times as a truck driver.</p>

<ul style='margin-left:-25px;'>
<li>Simple, elegant and functional</li>
<li>No ads</li>
<li>No commercial 'pro' version</li>
<li><a href='https://akaflieg-freiburg.github.io/addhoursandminutes/privacy'>Does not spy on you</a></li>
<li><a href='https://github.com/Akaflieg-Freiburg/addhoursandminutes'>100% Open Source</a></li>
<li>Written without commercial interest</li>
</ul>

<p>This app is available on a variety of
platforms. <a href='https://akaflieg-freiburg.github.io/addhoursandminutes'>
Have a look at the homepage.</a></p>

<h3>Author</h3>

<p>
Stefan Kebekus<br>
Wintererstraße 77<br>
79104 Freiburg im Breisgau<br>
Germany
</p>


<h3>License</h3>

<p>This program is licensed under the
<a href='https://www.gnu.org/licenses/gpl-3.0-standalone.html'>GNU General
Public License V3</a>.</p>


<h3>Acknowledgements</h3>

<p>This program builds on a number of open source libraries, including
<a href='https://www.qt.io'>Qt</a>.</p>
").arg(projectVersion)
        // qmllint enable

        standardButtons: DialogButtonBox.Ok
    }

}
