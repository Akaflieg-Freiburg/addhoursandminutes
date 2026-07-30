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

import gui

pragma ComponentBehavior: Bound


Rectangle {
    id: hoursAndMinutes

    property string minutesEntered: ""
    property string hoursEntered: ""
    property int totalMinutes: 0
    property int maxNumDigits: 6


    SequentialAnimation {
        id: blinkAnimation

        PropertyAnimation {target: hoursAndMinutes; properties: "color"; to: "red"; duration: 50}
        PropertyAnimation {target: hoursAndMinutes; properties: "color"; to: "white"; duration: 50}
    }

    SequentialAnimation {
        id: clearAnimation

        PropertyAnimation {target: hoursAndMinutes; properties: "color"; to: "teal"; duration: 50}
        PropertyAnimation {target: hoursAndMinutes; properties: "color"; to: "white"; duration: 50}
    }

    function convertToHoursAndMinutes(minutes) {
        // Compute "Hours : Minutes" representation of totalMinutes
        var result = ""
        var absMinutes = Math.abs(minutes)
        if (minutes < 0) {
            result = "-"
        }
        if (absMinutes < 60) {
            result = result + absMinutes.toString()
        } else {
            var m = absMinutes % 60
            var h = (absMinutes - m) / 60
            if (m < 10) {
                result = result + h.toLocaleString(Qt.locale(), "f", 0) + ":0" + m.toString()
            } else {
                result = result + h.toLocaleString(Qt.locale(), "f", 0) + ":" + m.toString()
            }
        }
        return result
    }

    function getMinutesForCurrentLine() {
        var minutesForCurrentLine = 0
        if (minutesEntered !== "") {
            minutesForCurrentLine = parseInt(minutesEntered)
        }
        if (hoursEntered !== "") {
            minutesForCurrentLine = minutesForCurrentLine + 60*parseInt(hoursEntered)
        }
        return minutesForCurrentLine
    }

    function printCurrentLine() {
        var result = ""

        if (hoursEntered !== "") {
            result = result + parseInt(hoursEntered).toLocaleString() + ":"
            if (minutesEntered.length === 0) {
                result = result + "00"
            } else if (minutesEntered.length === 1) {
                result = result + "0" + minutesEntered
            } else {
                result = result + minutesEntered
            }
            return result
        }

        if (minutesEntered === "") {
            return "0"
        }
        return minutesEntered
    }


    focus: true

    Component.onCompleted: splitView.restoreState(settings.splitView)
    Component.onDestruction: settings.splitView = splitView.saveState()

    Settings {
        id: settings

        property var splitView
    }

    SplitView {
        id: splitView
        anchors.fill: parent
        orientation: Qt.Vertical

        // Persist the layout whenever the user finishes dragging the handle;
        // Component.onDestruction alone is not reliable on mobile platforms
        onResizingChanged: if (!resizing) settings.splitView = splitView.saveState()

        handle: Item {
            id: handleDelegate

            implicitHeight: 12

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "teal"
                width: 24
                height: 3
                radius: height
            }

            containmentMask: Item {
                y: -1*handleDelegate.height

                width: handleDelegate.width
                height: 3*handleDelegate.height
            }
        }

        Control {
            id: lvContainer

            SplitView.fillHeight: true
            SplitView.minimumHeight: 4*font.pixelSize

            ListView {
                id: listView

                anchors.fill: lvContainer
                anchors.topMargin: 0.5*Style.fontPixelSize
                anchors.bottomMargin: 0.5*Style.fontPixelSize
                anchors.leftMargin: parent.SafeArea.margins.left
                anchors.rightMargin: parent.SafeArea.margins.right

                clip: true

                delegate: Item {
                    id: delegateParent

                    required property bool isSum
                    required property string operator
                    required property string operand

                    height: Style.fontPixelSize*1.2
                    width: listView.width

                    Text {
                        id: operatorText
                        anchors.left: parent.left
                        anchors.leftMargin: 2*Style.fontPixelSize
                        color: "teal"
                        text: delegateParent.operator
                        font.pixelSize: Style.fontPixelSize
                        font.family: "Monospace"
                    }
                    Text {
                        id: operandText
                        anchors.right: parent.right
                        anchors.rightMargin: 2*Style.fontPixelSize
                        text: delegateParent.operand
                        font.pixelSize: Style.fontPixelSize
                        font.family: "Monospace"
                        font.bold: delegateParent.isSum
                    }
                }

                model: ListModel {
                    ListElement {
                        operator: ''
                        operand: '0'
                        isSum: false
                    }
                }
            }
        }

        Keypad {
            id: keypad

            SplitView.minimumHeight: implicitHeight
            SplitView.maximumHeight: 2*implicitHeight
            SplitView.preferredHeight: {
                if (Qt.platform.os === "android") {
                    return 1.4*implicitHeight
                }

                return implicitHeight
            }

            onBackspacePressed: {
                var i = listView.model.count - 1
                if (listView.model.get(i).operator === "=") {
                    return
                }
                if (listView.model.get(i).operator === "E") {
                    return
                }

                var carryOver = ""

                if (hoursAndMinutes.hoursEntered.length > 0) {
                    carryOver = hoursAndMinutes.hoursEntered.charAt(hoursAndMinutes.hoursEntered.length-1)
                    hoursAndMinutes.hoursEntered = hoursAndMinutes.hoursEntered.substring(0, hoursAndMinutes.hoursEntered.length-1)
                }
                if (hoursAndMinutes.minutesEntered.length === 1) {
                    hoursAndMinutes.minutesEntered = ""
                } else {
                    hoursAndMinutes.minutesEntered = carryOver+hoursAndMinutes.minutesEntered.charAt(0)
                }

                listView.model.get(i).operand = hoursAndMinutes.printCurrentLine()
            }

            onClearPressed: {
                hoursAndMinutes.minutesEntered = ""
                hoursAndMinutes.hoursEntered = ""
                hoursAndMinutes.totalMinutes = 0

                listView.model.clear()
                clearAnimation.start()

                listView.model.append({"operator": "", "operand": "0", "isSum": false})
                listView.positionViewAtEnd()
            }

            onDigitPressed: (digit) => {
                if (hoursAndMinutes.hoursEntered.length >= hoursAndMinutes.maxNumDigits) {
                    PlatformAdapter.vibrateError()
                    blinkAnimation.start()
                    return
                }

                var i = listView.model.count - 1

                // If the current line is the result of a computation, insert a blank line and start a new computation
                if (listView.model.get(i).operator === "=") {
                    listView.model.append({"operator": "", "operand": "", "isSum": false})
                    listView.model.append({"operator": "", "operand": digit, "isSum": false})
                    hoursAndMinutes.minutesEntered = digit
                    hoursAndMinutes.hoursEntered = ""
                    hoursAndMinutes.totalMinutes = 0

                    // Position the view at the end
                    listView.positionViewAtEnd()
                    return
                }

                // In all other cases, add the digit entered to the current lines. Shift
                // strings around, so that "1:23" + "x" becomes "12:3x"
                if (hoursAndMinutes.minutesEntered === "") {
                    if (digit !== "0") {
                        hoursAndMinutes.minutesEntered = digit
                    }
                } else if (hoursAndMinutes.minutesEntered.length === 1) {
                    if (hoursAndMinutes.minutesEntered === "0") {
                        hoursAndMinutes.minutesEntered = digit
                    } else {
                        hoursAndMinutes.minutesEntered = hoursAndMinutes.minutesEntered + digit
                    }
                } else {
                    hoursAndMinutes.hoursEntered = hoursAndMinutes.hoursEntered + hoursAndMinutes.minutesEntered.charAt(0)
                    hoursAndMinutes.minutesEntered = hoursAndMinutes.minutesEntered.charAt(1) + digit
                }

                // Update display
                listView.model.get(i).operand = hoursAndMinutes.printCurrentLine()

                // Position the view at the end
                listView.positionViewAtEnd()
            }

            onOperatorPressed: (opCode) => {
                // Index of current line
                var i = listView.model.count - 1

                // If nothing has been entered on the current line yet, replace its pending operator instead of opening another line
                if ((opCode === "+" || opCode === "-")
                        && (listView.model.get(i).operator === "+" || listView.model.get(i).operator === "-")
                        && hoursAndMinutes.minutesEntered === "" && hoursAndMinutes.hoursEntered === "") {
                    listView.model.get(i).operator = opCode
                    return
                }

                if (listView.model.get(i).operator !== "=") {
                    listView.model.get(i).operand = hoursAndMinutes.convertToHoursAndMinutes(hoursAndMinutes.getMinutesForCurrentLine())
                }

                // Check operator of line, and adjust totalMinutes accordingly
                if (listView.model.get(i).operator === "") {
                    hoursAndMinutes.totalMinutes = hoursAndMinutes.getMinutesForCurrentLine()
                } else if (listView.model.get(i).operator === "+") {
                    hoursAndMinutes.totalMinutes = hoursAndMinutes.totalMinutes + hoursAndMinutes.getMinutesForCurrentLine()
                } else if (listView.model.get(i).operator === "-") {
                    hoursAndMinutes.totalMinutes = hoursAndMinutes.totalMinutes - hoursAndMinutes.getMinutesForCurrentLine()
                }
                hoursAndMinutes.minutesEntered = ""
                hoursAndMinutes.hoursEntered = ""

                // Sums may grow one digit beyond the maxNumDigits entry limit; only larger values are treated as overflow
                if (Math.floor(Math.abs(hoursAndMinutes.totalMinutes/60)) > Math.pow(10,hoursAndMinutes.maxNumDigits+1)-1) {
                    listView.model.append({"operator": "E", "operand": qsTr("Overflow"), "isSum": false})
                    listView.model.append({"operator": "", "operand": "", "isSum": false})
                    listView.model.append({"operator": "", "operand": "0", "isSum": false})
                    hoursAndMinutes.minutesEntered = ""
                    hoursAndMinutes.hoursEntered = ""
                    hoursAndMinutes.totalMinutes = 0

                    listView.positionViewAtEnd()
                    blinkAnimation.start()
                    return
                }

                if (opCode === "+" || opCode === "-") {
                    listView.model.append({"operator": opCode, "operand": "0", "isSum": false})
                } else if (opCode === "=") {
                    if (listView.model.get(i).operator !== "=") {
                        listView.model.append({"operator": opCode, "operand": hoursAndMinutes.convertToHoursAndMinutes(hoursAndMinutes.totalMinutes), "isSum": true})
                    }
                }

                // Position the view at the end
                listView.positionViewAtEnd()
            }

        }
    }
}
