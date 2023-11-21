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

Item {
    id: keypad

    signal backspacePressed()

    signal clearPressed()

    signal digitPressed(digit: string)

    signal operatorPressed(opCode: string)

    Component.onCompleted: forceActiveFocus()

    focus: true

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_0) {
            digitPressed("0")
            button0.down = true
            button0Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_1) {
            digitPressed("1")
            button1.down = true
            button1Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_2) {
            digitPressed("2")
            button2.down = true
            button2Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_3) {
            digitPressed("3")
            button3.down = true
            button3Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_4) {
            digitPressed("4")
            button4.down = true
            button4Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_5) {
            digitPressed("5")
            button5.down = true
            button5Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_6) {
            digitPressed("6")
            button6.down = true
            button6Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_7) {
            digitPressed("7")
            button7.down = true
            button7Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_8) {
            digitPressed("8")
            button8.down = true
            button8Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_9) {
            digitPressed("9")
            button9.down = true
            button9Timer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_Plus) {
            operatorPressed("+")
            buttonPlus.down = true
            buttonPlusTimer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_Minus) {
            operatorPressed("-")
            buttonMinus.down = true
            buttonMinusTimer.running = true
            event.accepted = true
        } else if ((event.key === Qt.Key_Equal || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
            operatorPressed("=")
            buttonEquals.down = true
            buttonEqualsTimer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_Delete || event.key === Qt.Key_C) {
            clearPressed()
            buttonClear.down = true
            buttonClearTimer.running = true
            event.accepted = true
        } else if (event.key === Qt.Key_Backspace) {
            backspacePressed()
            buttonClear.down = true
            buttonClearTimer.running = true
            event.accepted = true
            event.accepted = true
        }
    }

    implicitHeight: grid.implicitHeight

    GridLayout {
        id: grid

        anchors.fill: parent

        columnSpacing: 0
        rowSpacing: 0
        columns: 8


        // Row 1

        Rectangle {
            Layout.fillHeight: true
            Layout.rowSpan: 8
            Layout.minimumWidth: PlatformAdapter.safeInsetLeft
            color: "#e0e0e0"
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rowSpan: 8
            Layout.minimumWidth: 0
            color: "#e0e0e0"
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 3
            Layout.minimumHeight: 0
            color: "#e0e0e0"
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.maximumWidth: button1.Layout.maximumWidth
            color: "teal"
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rowSpan: 8
            Layout.minimumWidth: 0
            color: "teal"
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.rowSpan: 8
            Layout.minimumWidth: PlatformAdapter.safeInsetRight
            color: "teal"
        }


        // Row 1

        Rectangle {
            Layout.preferredHeight: 12
            Layout.fillWidth: true
            Layout.columnSpan: 3
            Layout.minimumHeight: 0
            color: "#e0e0e0"
        }

        Rectangle {
            Layout.preferredHeight: 12
            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.maximumWidth: button1.Layout.maximumWidth
            color: "teal"
        }


        // Row 2

        CalculatorButton {
            id: button7
            text: "7"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("7")

            Timer {
                id: button7Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }

        CalculatorButton {
            id: button8
            text: "8"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("8")

            Timer {
                id: button8Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }

        CalculatorButton {
            id: button9
            text: "9"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("9")

            Timer {
                id: button9Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }

        CalculatorButton {
            id: buttonClear
            palette { button: "teal"; buttonText: "white"}
            text: "C"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.backspacePressed()
            onPressAndHold: {
                keypad.clearPressed()
                PlatformAdapter.vibrateBrief()
            }

            Timer {
                id: buttonClearTimer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }


        // Row 3

        CalculatorButton {
            id: button4
            text: "4"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("4")

            Timer {
                id: button4Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }

        CalculatorButton {
            id: button5
            text: "5"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("5")

            Timer {
                id: button5Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }

        CalculatorButton {
            id: button6
            text: "6"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("6")

            Timer {
                id: button6Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }

        CalculatorButton {
            id: buttonMinus
            palette { button: "teal"; buttonText: "white"}
            text: "-"
            onClicked: keypad.operatorPressed("-")

            Timer {
                id: buttonMinusTimer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }


        // Row 4

        CalculatorButton {
            id: button1
            text: "1"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("1")

            Timer {
                id: button1Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }

        }

        CalculatorButton {
            id: button2
            text: "2"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("2")

            Timer {
                id: button2Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }

        CalculatorButton {
            id: button3
            text: "3"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("3")

            Timer {
                id: button3Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }

        CalculatorButton {
            id: buttonPlus
            palette { button: "teal"; buttonText: "white"}
            text: "+"
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.operatorPressed("+")

            Timer {
                id: buttonPlusTimer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }


        // Row 5

        CalculatorButton {
            id: button0
            text: "0"

            Layout.columnSpan: 3
            Layout.maximumWidth: -1

            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.digitPressed("0")

            Timer {
                id: button0Timer
                interval: 100;
                onTriggered: parent.down = undefined
            }

        }

        CalculatorButton {
            id: buttonEquals
            palette { button: "teal"; buttonText: "white"}
            text: "="
            palette { button: "#e0e0e0"; buttonText: "black"}
            onClicked: keypad.operatorPressed("=")

            Timer {
                id: buttonEqualsTimer
                interval: 100;
                onTriggered: parent.down = undefined
            }
        }


        // Row 6

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 3
            Layout.minimumHeight: 0
            color: "#e0e0e0"
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.maximumWidth: button1.Layout.maximumWidth

            color: "teal"
        }


        // Row 7

        Rectangle {
            Layout.fillWidth: true
            Layout.columnSpan: 3
            Layout.minimumHeight: PlatformAdapter.safeInsetBottom
            color: "#e0e0e0"
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumHeight: PlatformAdapter.safeInsetBottom
            Layout.maximumWidth: button1.Layout.maximumWidth

            color: "teal"
        }
    }

}

