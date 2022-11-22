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

import gui

Dialog {
    id: dlg

    // This is the text to be shown
    property var text: ({})

    leftMargin: PlatformAdapter.safeInsetLeft + Qt.application.font.pixelSize
    rightMargin: PlatformAdapter.safeInsetRight + Qt.application.font.pixelSize
    topMargin: PlatformAdapter.safeInsetTop + Qt.application.font.pixelSize
    bottomMargin: PlatformAdapter.safeInsetBottom + Qt.application.font.pixelSize

    // We center the dialog manually. The recommended "anchors.center: parent" does not seem to work
    x: PlatformAdapter.safeInsetLeft + (window.width-PlatformAdapter.safeInsetLeft-PlatformAdapter.safeInsetRight-width)/2.0
    y: PlatformAdapter.safeInsetTop + (window.height-PlatformAdapter.safeInsetTop-PlatformAdapter.safeInsetBottom-height)/2.0

    parent: Overlay.overlay
    modal: true
    
    ScrollView{
        id: sv

        anchors.fill: parent
        implicitWidth: 30*Qt.application.font.pixelSize
        contentWidth: availableWidth // Disable horizontal scrolling

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
