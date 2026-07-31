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

import QtQuick
import QtQuick.Layouts

import gui

Item {
    id: keypad

    signal backspacePressed()

    signal clearPressed()

    signal digitPressed(digit: string)

    signal operatorPressed(opCode: string)

    readonly property list<CalculatorButton> digitButtons: [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9]

    Component.onCompleted: forceActiveFocus()

    focus: true

    Keys.onPressed: function (event) {
        if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
            const digit = event.key - Qt.Key_0
            keypad.digitPressed(digit.toString())
            keypad.digitButtons[digit].flash()
            event.accepted = true
            return
        }

        switch (event.key) {
        case Qt.Key_Plus:
            keypad.operatorPressed("+")
            buttonPlus.flash()
            break
        case Qt.Key_Minus:
            keypad.operatorPressed("-")
            buttonMinus.flash()
            break
        case Qt.Key_Equal:
        case Qt.Key_Enter:
        case Qt.Key_Return:
            keypad.operatorPressed("=")
            buttonEquals.flash()
            break
        case Qt.Key_Delete:
            keypad.clearPressed()
            buttonClear.flash()
            break
        // Like a short press of the C button, the C key deletes a single digit; only Delete resets the calculator
        case Qt.Key_C:
        case Qt.Key_Backspace:
            keypad.backspacePressed()
            buttonClear.flash()
            break
        default:
            return
        }
        event.accepted = true
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
            Layout.minimumWidth: parent.SafeArea.margins.left
            color: Style.keypad
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rowSpan: 8
            Layout.minimumWidth: 0
            color: Style.keypad
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 3
            Layout.minimumHeight: 0
            color: Style.keypad
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.maximumWidth: button1.Layout.maximumWidth
            color: Style.teal
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rowSpan: 8
            Layout.minimumWidth: 0
            color: Style.teal
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.rowSpan: 8
            Layout.minimumWidth: parent.SafeArea.margins.right
            color: Style.teal
        }


        // Row 1

        Rectangle {
            Layout.preferredHeight: 12
            Layout.fillWidth: true
            Layout.columnSpan: 3
            Layout.minimumHeight: 0
            color: Style.keypad
        }

        Rectangle {
            Layout.preferredHeight: 12
            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.maximumWidth: button1.Layout.maximumWidth
            color: Style.teal
        }


        // Row 2

        CalculatorButton {
            id: button7
            text: "7"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("7")
        }

        CalculatorButton {
            id: button8
            text: "8"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("8")
        }

        CalculatorButton {
            id: button9
            text: "9"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("9")
        }

        CalculatorButton {
            id: buttonClear
            palette { button: Style.teal; buttonText: Style.tealText }
            text: "C"
            onClicked: keypad.backspacePressed()
            onPressAndHold: {
                keypad.clearPressed()
                PlatformAdapter.vibrateBrief()
            }
        }


        // Row 3

        CalculatorButton {
            id: button4
            text: "4"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("4")
        }

        CalculatorButton {
            id: button5
            text: "5"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("5")
        }

        CalculatorButton {
            id: button6
            text: "6"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("6")
        }

        CalculatorButton {
            id: buttonMinus
            palette { button: Style.teal; buttonText: Style.tealText }
            text: "-"
            onClicked: keypad.operatorPressed("-")
        }


        // Row 4

        CalculatorButton {
            id: button1
            text: "1"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("1")
        }

        CalculatorButton {
            id: button2
            text: "2"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("2")
        }

        CalculatorButton {
            id: button3
            text: "3"
            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("3")
        }

        CalculatorButton {
            id: buttonPlus
            palette { button: Style.teal; buttonText: Style.tealText }
            text: "+"
            onClicked: keypad.operatorPressed("+")
        }


        // Row 5

        CalculatorButton {
            id: button0
            text: "0"

            Layout.columnSpan: 3
            Layout.maximumWidth: -1

            palette { button: Style.keypad; buttonText: Style.keypadText }
            onClicked: keypad.digitPressed("0")
        }

        CalculatorButton {
            id: buttonEquals
            palette { button: Style.teal; buttonText: Style.tealText }
            text: "="
            onClicked: keypad.operatorPressed("=")
        }


        // Row 6

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 3
            Layout.minimumHeight: 0
            color: Style.keypad
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.maximumWidth: button1.Layout.maximumWidth

            color: Style.teal
        }


        // Row 7

        Rectangle {
            Layout.fillWidth: true
            Layout.columnSpan: 3
            Layout.minimumHeight: parent.SafeArea.margins.bottom
            color: Style.keypad
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumHeight: parent.SafeArea.margins.bottom
            Layout.maximumWidth: button1.Layout.maximumWidth

            color: Style.teal
        }
    }

}

