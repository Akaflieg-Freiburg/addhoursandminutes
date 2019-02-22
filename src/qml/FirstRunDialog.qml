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


import QtQuick 2.9
import QtQuick.Controls 2.4

Rectangle {
    id: firstTimeInfo
    
    anchors.fill: parent
    color: "teal"
    focus: true
    
    Flickable {
        id: flickable
        
        anchors.top: parent.top
        anchors.bottom: okButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 2*Qt.application.font.pixelSize
        anchors.topMargin: 2*Qt.application.font.pixelSize
            
        clip: true
        contentWidth: parent.width
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        
        Text {
            text: firstStartText
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: view.width
            wrapMode: Text.Wrap
            leftPadding: Qt.application.font.pixelSize
            rightPadding: Qt.application.font.pixelSize
            onLinkActivated: Qt.openUrlExternally(link)
        }
        
    }
        
    Button {
        id: okButton
            
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 2*Qt.application.font.pixelSize
        anchors.topMargin: 2*Qt.application.font.pixelSize
        
        text: qsTr("Continue")
        
        palette { button: "teal"; buttonText: "white"}
        
        background: Rectangle {
            color: okButton.down ? "teal" : "teal"
            border.color: "white"
            border.width: 1
            radius: 4
        }
        
        onClicked: {
            firstTimeInfo.visible = false
            view.visible = true
            view.focus = true
        }
        
        Keys.onPressed: {
            firstTimeInfo.visible = false
            view.visible = true
            view.focus = true
        }        
    }

    Keys.onPressed: {
        firstTimeInfo.visible = false
        view.visible = true
        view.focus = true
    }

}
