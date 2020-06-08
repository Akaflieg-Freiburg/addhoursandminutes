/***************************************************************************
 *   Copyright (C) 2018 - 2019 by Stefan Kebekus                           *
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
            icon.source: "/images/ic_menu_24px.svg"

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
                }
                MenuSeparator {visible: platform.os !== "wasm"}
                MenuItem {
                    visible: platform.os !== "wasm"
                    icon.source: "/images/ic_exit_to_app_24px.svg"
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

    Dialog {
        id: helpDialog

        anchors.centerIn: parent
        parent: Overlay.overlay

        width: Math.min(window.width-Qt.application.font.pixelSize, 40*Qt.application.font.pixelSize)
        modal: true

        standardButtons: DialogButtonBox.Ok

        title: qsTr("Help…")

        ScrollView {
            anchors.fill: parent
            width: helpDialog.availableWidth

            Label {
                width: helpDialog.availableWidth
                wrapMode: Text.Wrap
                leftPadding: Qt.application.font.pixelSize
                rightPadding: Qt.application.font.pixelSize
                onLinkActivated: Qt.openUrlExternally(link)
                textFormat: Text.RichText
                text: "<h4>Enter times</h4><p>In order to enter the time <strong>1 hour and 23 minutes</strong>, simply press the keys <strong>1</strong>, <strong>2</strong> and <strong>3</strong>.</p><h4>Reset</h4><p>To reset the calculator, press and hold the key <strong>C</strong>.</p>"
            }

        } // ScrollView
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
