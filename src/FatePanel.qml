// FatePanel.qml: Window section for tracking fate
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
	id: fatePanel
	color: "violet"

	ValueDisplay
	{
		id: fateDisplay
		height: parent.height/2
		width: parent.width/8
		anchors.centerIn: parent
	}

	AdjustButton {
		adjustment: -1
		valueDisplay: fateDisplay
		anchors.right: fateDisplay.left
		anchors.rightMargin: 20
		anchors.verticalCenter: parent.verticalCenter
			height: parent.height * 3/5
			width: parent.width /5
	}

	AdjustButton {
		id: addOne
		adjustment: 1
		valueDisplay: fateDisplay

		anchors.left: fateDisplay.right
		anchors.leftMargin: 20
		anchors.verticalCenter: parent.verticalCenter
			height: parent.height * 3/5
			width: parent.width /5
	}

	AdjustButton {
		adjustment: 7
		valueDisplay: fateDisplay

		anchors.left: addOne.right
		anchors.leftMargin: 0
		anchors.verticalCenter: parent.verticalCenter
			height: parent.height * 3/5
			width: parent.width /5
	}
}
