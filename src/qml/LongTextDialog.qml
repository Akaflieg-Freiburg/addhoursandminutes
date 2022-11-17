/***************************************************************************
 *   Copyright (C) 2019-2021 by Stefan Kebekus                             *
 *   stefan.kebekus@gmail.com                                              *
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

import QtQuick
import QtQuick.Controls

Dialog {
    id: dlg

    // This is the text to be shown
    property var text: ({})

    leftMargin: window.leftScreenMargin + Qt.application.font.pixelSize
    rightMargin: window.rightScreenMargin + Qt.application.font.pixelSize
    topMargin: window.topScreenMargin + Qt.application.font.pixelSize
    bottomMargin: window.bottomScreenMargin + Qt.application.font.pixelSize

    // We center the dialog manually. The recommended "anchors.center: parent" does not seem to work
    x: window.leftScreenMargin + (window.width-window.leftScreenMargin-window.rightScreenMargin-width)/2.0
    y: window.topScreenMargin + (window.height-window.topScreenMargin-window.bottomScreenMargin-height)/2.0

    parent: Overlay.overlay
    modal: true
    
    ScrollView{
        id: sv

        anchors.fill: parent
        implicitWidth: 30*Qt.application.font.pixelSize
        contentWidth: availableWidth // Disable horizontal scrolling

        // The following code guarantees that the scroll bar is shown initially. If it is not used, it is faded out after half a second or so.
        ScrollBar.vertical.policy: (height < contentHeight) ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
        ScrollBar.vertical.interactive: false

        clip: true

        Label {
            id: lbl
            text: dlg.text
            width: sv.availableWidth
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.Wrap
            onLinkActivated: (link) => Qt.openUrlExternally(link)
        } // Label

    } // ScrollView
    
} // Dialog
