/***************************************************************************
 *   Copyright (C) 2018 by Stefan Kebekus                                  *
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
import QtQuick.Controls 2.2

ScrollView {
    id: view
    property string text

    Flickable {
        clip: true
        contentWidth: parent.width
        
        Text {
            text: view.text
            width: parent.width
            wrapMode: Text.Wrap
            leftPadding: Qt.application.font.pixelSize*0.5
            rightPadding: Qt.application.font.pixelSize*0.5
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }
}
