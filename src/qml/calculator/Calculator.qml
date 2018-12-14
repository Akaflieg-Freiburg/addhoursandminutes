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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

Rectangle {
    id: hoursAndMinutes

    property string minutesEntered: ""
    property string hoursEntered: ""
    property int totalMinutes: 0
    property int maxNumDigits: 6

    property int fontpixelsize: Qt.application.font.pixelSize*1.5
    property real formfactor: 2.51

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

    function backSpace() {
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

    function addDigit(digit) {
        if (hoursEntered.length >= maxNumDigits) {
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

        // In all other cases, add the digit entered to the current lines. Shift strings around, so that "1:23" + "x" becomes "12:3x"
        if (minutesEntered === "") {
            if (digit !== "0") {
                minutesEntered = digit
            }
        } else if (minutesEntered.length === 1) {
            minutesEntered = minutesEntered + digit
        } else {
            hoursEntered = hoursEntered + minutesEntered.charAt(0)
            minutesEntered = minutesEntered.charAt(1) + digit
        }

        // Update display
        listView.model.get(i).operand = printCurrentLine()

        // Position the view at the end
        listView.positionViewAtEnd()
    }

    function addOperator(opCode) {
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
                listView.model.append({"operator": opCode, "operand": convertToHoursAndMinutes(totalMinutes)})
            }
        }

        // Position the view at the end
        listView.positionViewAtEnd()
    }

    function clear() {
        minutesEntered = ""
        hoursEntered = ""
        totalMinutes = 0

        listView.model.clear()
        clearAnimation.start()

        listView.model.append({"operator": "", "operand": "0"})
        listView.positionViewAtEnd()
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_0) {
            button0.clicked()
        } else if (event.key === Qt.Key_1) {
            button1.clicked()
        } else if (event.key === Qt.Key_2) {
            button2.clicked()
        } else if (event.key === Qt.Key_3) {
            button3.clicked()
        } else if (event.key === Qt.Key_4) {
            button4.clicked()
        } else if (event.key === Qt.Key_5) {
            button5.clicked()
        } else if (event.key === Qt.Key_6) {
            button6.clicked()
        } else if (event.key === Qt.Key_7) {
            button7.clicked()
        } else if (event.key === Qt.Key_8) {
            button8.clicked()
        } else if (event.key === Qt.Key_9) {
            button9.clicked()
        } else if (event.key === Qt.Key_Plus) {
            buttonPlus.clicked()
        } else if (event.key === Qt.Key_Minus) {
            buttonMinus.clicked()
        } else if ((event.key === Qt.Key_Equals || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
            buttonEquals.clicked()
        } else if (event.key === Qt.Key_Delete || event.key === Qt.Key_C) {
            hoursAndMinutes.clear()
        } else if (event.key === Qt.Key_Backspace) {
            backSpace()
        }
        event.accepted = true
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            Layout.preferredWidth: 110

            delegate: Item {
                height: fontpixelsize*1.2
                width: parent.width
                Text {
                    id: operator
                    x: 6
                    color: "teal"
                    text: model.operator
                    font.pixelSize: fontpixelsize
                }
                Text {
                    id: operand
                    anchors.right: parent.right
                    anchors.rightMargin: 22
                    text: model.operand
                    font.pixelSize: fontpixelsize
                }
            }

            model: ListModel {
                ListElement {
                    operator: ""
                    operand: "0"
                }
            }
        }

        Rectangle {
            height: 1
            Layout.fillWidth: true
            color: "gray"
            Layout.preferredHeight: 1
            Layout.rowSpan: 1
        }

        GridLayout {
            columnSpacing: 0
            rowSpacing: 0
            rows: 2
            columns: 4

            Button {
                id: button7
                text: "7"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("7")
            }

            Button {
                id: button8
                text: "8"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("8")
            }

            Button {
                id: button9
                text: "9"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("9")
            }

            Button {
                id: buttonClear
                palette { button: "teal"; buttonText: "white"}
                text: "C"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.backSpace()
                onPressAndHold: hoursAndMinutes.clear()
            }

            Button {
                id: button4
                text: "4"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("4")
            }

            Button {
                id: button5
                text: "5"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("5")
            }

            Button {
                id: button6
                text: "6"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("6")
            }

            Button {
                id: buttonMinus
                palette { button: "teal"; buttonText: "white"}
                text: "-"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addOperator("-")
            }

            Button {
                id: button1
                text: "1"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("1")
            }

            Button {
                id: button2
                text: "2"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("2")
            }

            Button {
                id: button3
                text: "3"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("3")
            }

            Button {
                id: buttonPlus
                palette { button: "teal"; buttonText: "white"}
                text: "+"
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addOperator("+")
            }

            Button {
                id: button0
                text: "0"
                Layout.columnSpan: 3
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addDigit("0")
            }

            Button {
                id: buttonEquals
                palette { button: "teal"; buttonText: "white"}
                text: "="
                Layout.minimumHeight: formfactor*fontpixelsize
                Layout.fillWidth: true
                font.pixelSize: fontpixelsize
                onClicked: hoursAndMinutes.addOperator("=")
            }
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
