/***************************************************************************
 *   Copyright (C) 2019-2023 by Stefan Kebekus                             *
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
    parent: Overlay.overlay

    property real avHeight: ((Qt.platform.os === "android") ? PlatformAdapter.wHeight : parent.height)-2*font.pixelSize-parent.SafeArea.margins.top-parent.SafeArea.margins.bottom
    property real avWidth: ((Qt.platform.os === "android") ? PlatformAdapter.wWidth : parent.width)-2*font.pixelSize-parent.SafeArea.margins.left-parent.SafeArea.margins.right

    // We center the dialog manually, taking care of safe insets
    x: parent.SafeArea.margins.left + font.pixelSize + (avWidth-width)/2.0
    y: parent.SafeArea.margins.top + font.pixelSize + (avHeight-height)/2.0

    height: Math.min(avHeight, implicitHeight)
    width: Math.min(avWidth, 40*font.pixelSize)

}
