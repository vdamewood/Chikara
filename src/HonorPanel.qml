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
import QtQuick.Layouts 1.0

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
	}

	Button {
		anchors.right: honorDisplay.left
		anchors.rightMargin: 20
		anchors.verticalCenter: parent.verticalCenter
			height: parent.height * 3/5
			width: parent.width /4

		background: Rectangle
		{
			radius: 20
			color: "gray"
		}

		onClicked: honorDisplay.value -= 1
	}

	Button {
		anchors.left: honorDisplay.right
		anchors.leftMargin: 20
		anchors.verticalCenter: parent.verticalCenter
			height: parent.height * 3/5
			width: parent.width /4

		background: Rectangle
		{
			radius: 20
			color: "gray"
		}

		onClicked: honorDisplay.value += 1
	}

	RowLayout
	{
		id: honorInitLayout
		spacing: 10
		anchors.fill: parent;

		HonorInitButton
		{
			Layout.fillWidth: true
			Layout.fillHeight: true
			value: 10
			onClicked:
			{
				honorInitLayout.visible = false
				honorDisplay.value = 10
				honorDisplay.visible = true
			}
		}

		HonorInitButton
		{
			Layout.fillWidth: true
			Layout.fillHeight: true
			value: 11
			onClicked:
			{
				honorInitLayout.visible = false
				honorDisplay.value = 11
				honorDisplay.visible = true
			}
		}

		HonorInitButton
		{
			Layout.fillWidth: true
			Layout.fillHeight: true
			value: 12
			onClicked:
			{
				honorInitLayout.visible = false
				honorDisplay.value = 12
				honorDisplay.visible = true
			}
		}
	}
}
