// BidButton.qml: Button to set a bid
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

Button {
	property int bid
	property ValueDisplay bidDisplay

	height: parent.height * 3/5
	width: parent.width /5

	contentItem: Text
	{
		text: bid.toString()
		font.pixelSize: 55
		color: "black"
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
	}

	background: Rectangle
	{
		radius: 20
		color: "gray"
	}

	onClicked: {
		bidDisplay.value = bid
		parent.state = 2
	}
}
