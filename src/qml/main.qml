/***************************************************************************
 *   Copyright (C) 2018 - 2023 by Stefan Kebekus                           *
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
import QtQuick.Layouts

Window {
    id: window

    width: toolBar.font.pixelSize*15*1.5
    height: toolBar.font.pixelSize*20*1.5
    minimumWidth: toolBar.font.pixelSize*12*1.5
    minimumHeight: toolBar.font.pixelSize*14*1.5

    Settings {
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
    }

    flags: (Qt.platform.os === "ios") ? Qt.ExpandedClientAreaHint : Qt.Window

    title: qsTr("Add Times")

    visible: true

    ColumnLayout {
        anchors.fill: parent

        ToolBar {
            id: toolBar

            Layout.fillWidth: true
            background: Rectangle { color: "teal" }

            RowLayout {
                anchors.fill: parent

                ToolButton {
                    id: toolButton

                    background: Rectangle { color: "teal" }

                    icon.source: "/images/ic_menu_24px.svg"
                    icon.color: "white"

                    onClicked: mainMenu.open()

                    Menu {
                        id: mainMenu

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

<p>To reset the calculator, press and hold the key <strong>C</strong>.</p>

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
  It helps with the recording of machine running times, with the addition of
  flight times in your pilot's flight log, or your driving times as a truck
  driver.</p>

<ul style='margin-left:-25px;'>
<li>Simple, elegant and functional</li>
<li>No ads</li>
<li>No commerical 'pro' version</li>
<li><a href='https://akaflieg-freiburg.github.io/addhoursandminutes/privacy'>Does not spy on you</a></li>
<li><a href='https://github.com/Akaflieg-Freiburg/addhoursandminutes'>100% Open Source</a></li>
<li>Written without commercial interest</li>
</ul>

<p>This app is available for a variety of
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

    Shortcut {
        sequence: StandardKey.Quit
        onActivated: Qt.quit()
    }

}
