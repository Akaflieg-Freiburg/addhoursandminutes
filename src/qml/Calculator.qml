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

pragma ComponentBehavior: Bound

import gui

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: hoursAndMinutes

    property string minutesEntered: ""
    property string hoursEntered: ""
    property int totalMinutes: 0
    property int maxNumDigits: 6

    property real fontpixelsize: Application.font.pixelSize*fontScale // qmllint disable
    property real formfactor: 2.5
    property real buttonMinHeight: fontpixelsize*2
    property real buttonMaxHeight: fontpixelsize*formfactor


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

    ColumnLayout {
        anchors.fill: parent

        Item {
            id: lvContainer

            Layout.fillHeight: true
            Layout.fillWidth: true

            ListView {
                id: listView

                anchors.fill: lvContainer
                anchors.topMargin: 0.5*hoursAndMinutes.fontpixelsize
                anchors.bottomMargin: 0.5*hoursAndMinutes.fontpixelsize
                anchors.leftMargin: PlatformAdapter.safeInsetLeft
                anchors.rightMargin: PlatformAdapter.safeInsetRight

                clip: true

                delegate: Item {
                    id: delegateParent

                    required property bool isSum
                    required property string operator
                    required property string operand

                    height: hoursAndMinutes.fontpixelsize*1.2
                    width: listView.width

                    Text {
                        id: operatorText
                        anchors.left: parent.left
                        anchors.leftMargin: 2*hoursAndMinutes.fontpixelsize
                        color: "teal"
                        text: delegateParent.operator
                        font.pixelSize: hoursAndMinutes.fontpixelsize
                        font.family: "Monospace"
                    }
                    Text {
                        id: operandText
                        anchors.right: parent.right
                        anchors.rightMargin: 2*hoursAndMinutes.fontpixelsize
                        text: delegateParent.operand
                        font.pixelSize: hoursAndMinutes.fontpixelsize
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
            Layout.fillHeight: true
            Layout.fillWidth: true

            onBackspacePressed: {
                var i = listView.model.count - 1
                if (listView.model.get(i).operator === "=") {
                    return
                }
                if (listView.model.get(i).operator === "E") {
                    return
                }

                var carryOver = ""

                if (hoursEntered.length > 0) {
                    carryOver = hoursEntered.charAt(hoursEntered.length-1)
                    hoursEntered = hoursEntered.substring(0, hoursEntered.length-1)
                }
                if (minutesEntered.length === 1) {
                    minutesEntered = ""
                } else {
                    minutesEntered = carryOver+minutesEntered.charAt(0)
                }

                listView.model.get(i).operand = printCurrentLine()
            }

            onClearPressed: {
                minutesEntered = ""
                hoursEntered = ""
                totalMinutes = 0

                listView.model.clear()
                clearAnimation.start()

                listView.model.append({"operator": "", "operand": "0"})
                listView.positionViewAtEnd()
            }

            onDigitPressed: (digit) => {
                if (hoursEntered.length >= maxNumDigits) {
                    PlatformAdapter.vibrateError()
                    blinkAnimation.start()
                    return
                }

                var i = listView.model.count - 1

                // If the current line is the result of a computation, insert a blank line and start a new computation
                if (listView.model.get(i).operator === "=") {
                    listView.model.append({"operator": "", "operand": ""})
                    listView.model.append({"operator": "", "operand": digit})
                    minutesEntered = digit
                    hoursEntered = ""
                    totalMinutes = 0

                    // Position the view at the end
                    listView.positionViewAtEnd()
                    return
                }

                // In all other cases, add the digit entered to the current lines. Shift
                // strings around, so that "1:23" + "x" becomes "12:3x"
                if (minutesEntered === "") {
                    if (digit !== "0") {
                        minutesEntered = digit
                    }
                } else if (minutesEntered.length === 1) {
                    if (minutesEntered === "0") {
                        minutesEntered = digit
                    } else {
                        minutesEntered = minutesEntered + digit
                    }
                } else {
                    hoursEntered = hoursEntered + minutesEntered.charAt(0)
                    minutesEntered = minutesEntered.charAt(1) + digit
                }

                // Update display
                listView.model.get(i).operand = printCurrentLine()

                // Position the view at the end
                listView.positionViewAtEnd()
            }

            onOperatorPressed: (opCode) => {
                // Index of current line
                var i = listView.model.count - 1
                if (listView.model.get(i).operator !== "=") {
                    listView.model.get(i).operand = convertToHoursAndMinutes(getMinutesForCurrentLine())
                }

                // Check operator of line, and adjust totalMinutes accordingly
                if (listView.model.get(i).operator === "") {
                    totalMinutes = getMinutesForCurrentLine()
                } else if (listView.model.get(i).operator === "+") {
                    totalMinutes = totalMinutes + getMinutesForCurrentLine()
                } else if (listView.model.get(i).operator === "-") {
                    totalMinutes = totalMinutes - getMinutesForCurrentLine()
                }
                minutesEntered = ""
                hoursEntered = ""

                if (Math.floor(Math.abs(totalMinutes/60)) > Math.pow(10,maxNumDigits+1)-1) {
                    listView.model.append({"operator": "E", "operand": qsTr("Overflow")})
                    listView.model.append({"operator": "", "operand": ""})
                    listView.model.append({"operator": "", "operand": "0"})
                    minutesEntered = ""
                    hoursEntered = ""
                    totalMinutes = 0

                    listView.positionViewAtEnd()
                    blinkAnimation.start()
                    return
                }

                if (opCode === "+" || opCode === "-") {
                    listView.model.append({"operator": opCode, "operand": "0"})
                } else if (opCode === "=") {
                    if (listView.model.get(i).operator !== "=") {
                        listView.model.append({"operator": opCode, "operand": convertToHoursAndMinutes(totalMinutes), "isSum": true})
                    }
                }

                // Position the view at the end
                listView.positionViewAtEnd()
            }

        }
    }
}
