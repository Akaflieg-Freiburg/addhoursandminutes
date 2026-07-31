/***************************************************************************
 *   Copyright (C) 2026 by Stefan Kebekus                                  *
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

pragma Singleton

import QtQuick

QtObject {
    readonly property real fontPixelSize: (Qt.platform.os === "android") ? 1.6*Application.font.pixelSize : 1.2*Application.font.pixelSize

    // Follows the system color scheme; Qt.Unknown deliberately counts as light
    readonly property bool isDark: Application.styleHints.colorScheme === Qt.Dark

    // Brand color, used for the toolbar, the operator keys and the splitter handle
    readonly property color teal: isDark ? "#00695c" : "teal"
    // Text and icons on top of the brand color
    readonly property color tealText: "white"
    // Background of the digit keys and the filler areas around them
    readonly property color keypad: isDark ? "#2f2f2f" : "#e0e0e0"
    // Text on the digit keys
    readonly property color keypadText: isDark ? "#eff0f2" : "black"
    // Background of the calculator tape and the window
    readonly property color display: isDark ? "#121212" : "white"
    // Text on the calculator tape
    readonly property color displayText: isDark ? "#eff0f2" : "black"
    // Teal-tinted text on the display background: operators, hyperlinks.
    // Plain teal has too little contrast against the dark background.
    readonly property color accent: isDark ? "#4db6ac" : "teal"
    // Flash color of the error animation
    readonly property color error: isDark ? "#ef5350" : "red"

    // Palette for menus and dialogs, mirroring the light/dark palettes of the
    // Qt Quick "Basic" style. Explicit palette bindings on the popups are
    // required because Qt does not push a system color scheme change into
    // popups that already exist (their default palette is a snapshot).
    readonly property color popupWindow: isDark ? "#1e1e1e" : "white"
    readonly property color popupWindowText: isDark ? "#d4d6d8" : "#26282a"
    readonly property color popupText: isDark ? "#eff0f2" : "#353637"
    readonly property color popupButton: isDark ? "#2f2f2f" : "#e0e0e0"
    readonly property color popupButtonText: isDark ? "#d4d6d8" : "#26282a"
    readonly property color popupMid: isDark ? "#626262" : "#bdbdbd"
    readonly property color popupDark: isDark ? "#c8c9cb" : "#353637"
}
