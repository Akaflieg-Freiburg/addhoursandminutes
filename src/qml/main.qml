/***************************************************************************
 *   Copyright (C) 2018 - 2020 by Stefan Kebekus                           *
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


import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    id: window
    width: Qt.application.font.pixelSize*14*1.5
    height: Qt.application.font.pixelSize*18*1.5
    minimumWidth: Qt.application.font.pixelSize*12*1.5
    minimumHeight: Qt.application.font.pixelSize*14*1.5
    visible: true

    header: ToolBar {

        ToolButton {
            icon.source: Qt.platform.os !== "wasm" ? "/images/ic_menu_24px.svg" : "/images/ic_menu_black_24dp.png"

            onClicked: mainMenu.open()

            Menu {
                id: mainMenu

                MenuItem {
                    icon.source: Qt.platform.os !== "wasm" ? "/images/ic_help_24px.svg" : "/images/ic_help_black_24dp.png"
                    text: qsTr("Help")
                    onTriggered: helpDialog.open()
                }

                MenuItem {
                    icon.source: Qt.platform.os !== "wasm" ? "/images/ic_info_24px.svg" : "/images/ic_info_black_24dp.png"
                    text: qsTr("About")
                    onTriggered: infoDialog.open()
                }

                MenuSeparator {}

                MenuItem {
                    enabled: Qt.platform.os !== "wasm"
                    icon.source: Qt.platform.os !== "wasm" ? "/images/ic_exit_to_app_24px.svg" : "/images/ic_exit_to_app_black_24dp.png"
                    text: qsTr("Exit")
                    onTriggered: Qt.quit()
                }
            }
        }
    }

    Calculator {
        anchors.fill: parent
        focus: true;
    }

    LongTextDialog {
        id: helpDialog
        anchors.centerIn: parent

        title: qsTr("Help…")

        text: qsTr("
<h4>Enter times</h4>

<p>In order to enter the time <strong>1 hour and 23 minutes</strong>, simply press the keys
<strong>1</strong>, <strong>2</strong> and <strong>3</strong>.</p>

<h4>Reset</h4>

<p>To reset the calculator, press and hold the key <strong>C</strong>.</p>
")

        standardButtons: DialogButtonBox.Ok
    }

    LongTextDialog {
        id: infoDialog
        anchors.centerIn: parent
        parent: Overlay.overlay

        title: qsTr("Help…")

        text: qsTr("
<h3>Add Hours and Minutes</h3>

<h4>Version %1</h4>

<p>This is a simple calculator app that adds times given in hours and minutes.
  It helps with the recording of machine running times, with the addition of
  flight times in your pilot's flight log, or your driving times as a truck
  driver.</p>

<ul>
<li>Simple, elegant and functional</li>
<li>No ads</li>
<li>No commerical 'pro' version</li>
<li>Does not spy on you</li>
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

        standardButtons: DialogButtonBox.Ok

    }

    Shortcut {
        sequence: StandardKey.Quit
        onActivated: Qt.quit()
    }
    
    Shortcut {
        sequence: StandardKey.Close
        onActivated: Qt.quit()
    }

}
