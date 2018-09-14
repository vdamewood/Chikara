// BidPanel.qml: Window section for tracking bids
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
	id: bidPanel
	color: "black"

	// States:
	// 0: Displaying Bid
	// 1: Selecting Bid
	// 2: Hiding Bid
	property int state: 0

	ValueDisplay
	{
		id: bidDisplay
		nullable: true
		height: parent.height/2
		width: parent.width/8
		anchors.centerIn: parent
	}

	Button
	{
		id: startBidButton
		onClicked: bidPanel.state = 1
		anchors.left: bidDisplay.right
		anchors.leftMargin: parent.width / 20
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height/2
		width: parent.width/5
	}

	BidButton {
		id: button1
		bid: 1
		bidDisplay: bidDisplay

		anchors.right: button2.left
		//anchors.rightMargin: 20
		anchors.verticalCenter: parent.verticalCenter
		visible: false
	}

	BidButton {
		id: button2
		bid: 2
		bidDisplay: bidDisplay

		//anchors.centerIn: parent
		anchors.right: button3.left
		//anchors.rightMargin: 20
		anchors.verticalCenter: parent.verticalCenter

		visible: false
	}

	BidButton {
		id: button3
		bid: 3
		bidDisplay: bidDisplay
		anchors.centerIn: parent
		//anchors.right: fateDisplay.left
		//anchors.rightMargin: 20
		//anchors.verticalCenter: parent.verticalCenter

		visible: false
	}

	BidButton {
		id: button4
		bid: 4
		bidDisplay: bidDisplay

		anchors.left: button3.right
		//anchors.rightMargin: 20
		anchors.verticalCenter: parent.verticalCenter

		visible: false
	}

	BidButton {
		id: button5
		bid: 5
		bidDisplay: bidDisplay

		anchors.left: button4.right
		//anchors.right: fateDisplay.left
		//anchors.rightMargin: 20
		anchors.verticalCenter: parent.verticalCenter

		visible: false
	}

	Button {
		id: revealButton
		anchors.centerIn: parent
		height: parent.height * 3/5
		width: parent.width * 3/5

		background: Rectangle
		{
			radius: 20
			color: "gray"
		}

		onClicked: bidPanel.state = 0
		visible: false
	}
	onStateChanged: {
		switch (state)
		{
			case 0:
				bidDisplay.visible = true;
				startBidButton.visible = true;
				button1.visible = false;
				button2.visible = false;
				button3.visible = false;
				button4.visible = false;
				button5.visible = false;
				revealButton.visible = false;
				break;
			case 1:
				bidDisplay.visible = false;
				startBidButton.visible = false;
				button1.visible = true;
				button2.visible = true;
				button3.visible = true;
				button4.visible = true;
				button5.visible = true;
				revealButton.visible = false;
				break;
			case 2:
				bidDisplay.visible = false;
				startBidButton.visible = false;
				button1.visible = false;
				button2.visible = false;
				button3.visible = false;
				button4.visible = false;
				button5.visible = false;
				revealButton.visible = true;
				break;
		}
	}
}
