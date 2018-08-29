// HonorPanel.qml: Window section for tracking honor
// Copyright 2018 Vincent Damewood
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle
{
	id: honorPanel
	color: "red"

	ValueDisplay
	{
		id: honorDisplay
		height: parent.height/2
		width: parent.width/8
		anchors.centerIn: parent
		visible: false
	}

	Button {
		id: decrementButton
		anchors.right: honorDisplay.left
		anchors.rightMargin: 20
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height * 3/5
		width: parent.width /4

		visible: false
		background: Rectangle
		{
			radius: 20
			color: "gray"
		}

		onClicked: honorDisplay.value -= 1
	}

	Button {
		id: incrementButton
		anchors.left: honorDisplay.right
		anchors.leftMargin: 20
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height * 3/5
		width: parent.width /4
		visible: false

		background: Rectangle
		{
			radius: 20
			color: "gray"
		}

		onClicked: honorDisplay.value += 1
	}

	HonorInitButton
	{
		id: lowInitButton

		anchors.right: midInitButton.left
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height * 4/5
		width: parent.width * 1/3
		value: 10
		onClicked:
		{
			honorDisplay.value = 10
			lowInitButton.visible = false
			midInitButton.visible = false
			highInitButton.visible = false
			decrementButton.visible = true
			honorDisplay.visible = true
			incrementButton.visible = true
		}
	}

	HonorInitButton
	{
		id: midInitButton
		anchors.centerIn: parent
		height: parent.height * 4/5
		width: parent.width * 1/3
		value: 11
		onClicked:
		{
			honorDisplay.value = 11
			lowInitButton.visible = false
			midInitButton.visible = false
			highInitButton.visible = false
			decrementButton.visible = true
			honorDisplay.visible = true
			incrementButton.visible = true
		}
	}

	HonorInitButton
	{
		id: highInitButton
		anchors.left: midInitButton.right
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height * 4/5
		width: parent.width * 1/3
		value: 12
		onClicked:
		{
			honorDisplay.value = 12
			lowInitButton.visible = false
			midInitButton.visible = false
			highInitButton.visible = false
			decrementButton.visible = true
			honorDisplay.visible = true
			incrementButton.visible = true
		}
	}
}
