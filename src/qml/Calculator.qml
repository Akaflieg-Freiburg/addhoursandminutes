/***************************************************************************
 *   Copyright (C) 2018 - 2022 by Stefan Kebekus                           *
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
import QtQuick.Controls.Basic
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

    property bool isPortrait: {
        return width < 1.2*height
    }


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
                listView.model.append({"operator": opCode, "operand": convertToHoursAndMinutes(totalMinutes), "isSum": true})
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

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_0) {
            hoursAndMinutes.addDigit("0")
            button0.down = true
            button0Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_1) {
            hoursAndMinutes.addDigit("1")
            button1.down = true
            button1Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_2) {
            hoursAndMinutes.addDigit("2")
            button2.down = true
            button2Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_3) {
            hoursAndMinutes.addDigit("3")
            button3.down = true
            button3Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_4) {
            hoursAndMinutes.addDigit("4")
            button4.down = true
            button4Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_5) {
            hoursAndMinutes.addDigit("5")
            button5.down = true
            button5Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_6) {
            hoursAndMinutes.addDigit("6")
            button6.down = true
            button6Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_7) {
            hoursAndMinutes.addDigit("7")
            button7.down = true
            button7Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_8) {
            hoursAndMinutes.addDigit("8")
            button8.down = true
            button8Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_9) {
            hoursAndMinutes.addDigit("9")
            button9.down = true
            button9Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_Plus) {
            hoursAndMinutes.addOperator("+")
            buttonPlus.down = true
            buttonPlusTimer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_Minus) {
            hoursAndMinutes.addOperator("-")
            buttonMinus.down = true
            buttonMinusTimer.running = true
            event.accepted = true
        } else if ((event.key === Qt.Key_Equal || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
            hoursAndMinutes.addOperator("=")
            buttonEquals.down = true
            buttonEqualsTimer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_Delete || event.key === Qt.Key_C) {
            hoursAndMinutes.clear()
            buttonClear.down = true
            buttonClearTimer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_Backspace) {
            backSpace()
            buttonClear.down = true
            buttonClearTimer.running = true
            event.accepted = true
            event.accepted = true
        }
    }

    GridLayout {
        columnSpacing: 0
        rowSpacing: 0
        rows: 3
        columns: 3
        flow: hoursAndMinutes.isPortrait ? GridLayout.TopToBottom : GridLayout.LeftToRight
        anchors.fill: parent

        Item {
            id: lvContainer

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 160
            Layout.preferredWidth: 110

            ListView {
                id: listView

                anchors.fill: lvContainer
                anchors.topMargin: 0.5*hoursAndMinutes.fontpixelsize
                anchors.bottomMargin: hoursAndMinutes.isPortrait ? 0.5*hoursAndMinutes.fontpixelsize : 0.5*hoursAndMinutes.fontpixelsize+PlatformAdapter.safeInsetBottom
                anchors.leftMargin: PlatformAdapter.safeInsetLeft
                anchors.rightMargin: hoursAndMinutes.isPortrait ? PlatformAdapter.safeInsetRight : 0

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

            Image {
                id: shadow1

                anchors.bottom: lvContainer.bottom
                anchors.left: lvContainer.left
                anchors.right: lvContainer.right
                height: hoursAndMinutes.fontpixelsize*0.25|0
                visible: hoursAndMinutes.isPortrait
                source: "/images/shadow_horizontal.png"
            }

            Image {
                id: shadow1a

                anchors.top: lvContainer.top
                anchors.left: lvContainer.left
                anchors.right: lvContainer.right
                height: hoursAndMinutes.fontpixelsize*0.25|0
                //                visible: !hoursAndMinutes.isPortrait
                source: "/images/shadow_top.png"
            }

            Image {
                id: shadow2

                anchors.top: lvContainer.top
                anchors.bottom: lvContainer.bottom
                anchors.right: lvContainer.right
                width: hoursAndMinutes.fontpixelsize*0.25|0
                visible: !hoursAndMinutes.isPortrait
                source: "/images/shadow_vertical.png"
            }

        }


        GridLayout {
            Layout.fillHeight: !hoursAndMinutes.isPortrait
            Layout.fillWidth: hoursAndMinutes.isPortrait

            columnSpacing: 0
            rowSpacing: 0
            rows: 2

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: hoursAndMinutes.isPortrait ? PlatformAdapter.safeInsetLeft : 0
                color: "#e0e0e0"
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: hoursAndMinutes.isPortrait
                color: "#e0e0e0"
            }

            GridLayout {
                id: keypad

                Layout.fillHeight: !hoursAndMinutes.isPortrait
                Layout.fillWidth: hoursAndMinutes.isPortrait

                Layout.preferredHeight: 4.2*hoursAndMinutes.buttonMaxHeight
                Layout.preferredWidth: 5*hoursAndMinutes.buttonMaxHeight
                Layout.minimumWidth: (hoursAndMinutes.width > 5*hoursAndMinutes.buttonMaxHeight) ? 5*hoursAndMinutes.buttonMaxHeight : hoursAndMinutes.width
                Layout.maximumWidth: 8*hoursAndMinutes.buttonMaxHeight
                columnSpacing: 0
                rowSpacing: 0
                columns: 4

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    Layout.minimumHeight: !hoursAndMinutes.isPortrait ? PlatformAdapter.safeInsetBottom : 0
                    color: "#e0e0e0"
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.minimumHeight: !hoursAndMinutes.isPortrait ? PlatformAdapter.safeInsetBottom : 0
                    color: "teal"
                }

                Button {
                    id: button7
                    text: "7"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("7")
                    }

                    Timer {
                        id: button7Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }

                Button {
                    id: button8
                    text: "8"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("8")
                    }

                    Timer {
                        id: button8Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }

                Button {
                    id: button9
                    text: "9"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("9")
                    }

                    Timer {
                        id: button9Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }

                }

                Button {
                    id: buttonClear
                    palette { button: "teal"; buttonText: "white"}
                    text: "C"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.backSpace()
                    }
                    onPressAndHold: {
                        hoursAndMinutes.clear()
                        PlatformAdapter.vibrateBrief()
                    }

                    Timer {
                        id: buttonClearTimer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }

                }

                Button {
                    id: button4
                    text: "4"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("4")
                    }

                    Timer {
                        id: button4Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }

                Button {
                    id: button5
                    text: "5"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("5")
                    }

                    Timer {
                        id: button5Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }

                Button {
                    id: button6
                    text: "6"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("6")
                    }

                    Timer {
                        id: button6Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }

                Button {
                    id: buttonMinus
                    palette { button: "teal"; buttonText: "white"}
                    text: "-"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    onClicked: {
                        hoursAndMinutes.addOperator("-")
                    }

                    Timer {
                        id: buttonMinusTimer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }

                Button {
                    id: button1
                    text: "1"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("1")
                    }

                    Timer {
                        id: button1Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }

                }

                Button {
                    id: button2
                    text: "2"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("2")
                    }

                    Timer {
                        id: button2Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }

                }

                Button {
                    id: button3
                    text: "3"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("3")
                    }

                    Timer {
                        id: button3Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }

                Button {
                    id: buttonPlus
                    palette { button: "teal"; buttonText: "white"}
                    text: "+"
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addOperator("+")
                    }

                    Timer {
                        id: buttonPlusTimer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }

                Button {
                    id: button0
                    text: "0"
                    Layout.fillHeight: true
                    Layout.columnSpan: 3
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addDigit("0")
                    }

                    Timer {
                        id: button0Timer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }

                }

                Button {
                    id: buttonEquals
                    palette { button: "teal"; buttonText: "white"}
                    text: "="
                    Layout.fillHeight: true
                    Layout.minimumHeight: hoursAndMinutes.buttonMinHeight
                    Layout.maximumHeight: hoursAndMinutes.buttonMaxHeight
                    Layout.fillWidth: true
                    font.pixelSize: hoursAndMinutes.fontpixelsize
                    palette { button: "#e0e0e0"; buttonText: "black"}
                    onClicked: {
                        hoursAndMinutes.addOperator("=")
                    }

                    Timer {
                        id: buttonEqualsTimer
                        interval: 100;
                        onTriggered: parent.down = undefined
                    }
                }


                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    Layout.minimumHeight: PlatformAdapter.safeInsetBottom
                    color: "#e0e0e0"
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.minimumHeight: PlatformAdapter.safeInsetBottom
                    color: "teal"
                }
            }


            Rectangle {
                Layout.columnSpan: 2
                Layout.fillHeight: true
                Layout.fillWidth: hoursAndMinutes.isPortrait
                color: "teal"
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: PlatformAdapter.safeInsetRight
                Layout.minimumHeight: PlatformAdapter.safeInsetRight
                color: "teal"
            }

        }
    }
}
