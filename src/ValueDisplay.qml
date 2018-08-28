// ValueDisplay.qml: Display a value
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

Rectangle
{
	id: display
	property int value
	property bool nullable: false
	color: "#ddd"

	radius: (height+width)/10
	Text
	{
		anchors.fill: parent
		anchors.topMargin: parent.height/10
		anchors.bottomMargin: parent.height/10
		anchors.leftMargin: parent.width/10
		anchors.rightMargin: parent.width/10
		text: (display.value == 0 && display.nullable) ? "-" : display.value.toString()
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
		fontSizeMode: Text.Fit
		minimumPixelSize: 1
		font.pointSize: parent.height == 0 ? 1 : parent.height
	}
}
