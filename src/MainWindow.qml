// MainWindow.qml: Primary user interface
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

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.11

ApplicationWindow
{
	id: mainWindow
	width: 640
	height: 600
	color: "white"
	visible: true

	ColumnLayout
	{
		spacing: 0
		anchors.fill: parent

		Rectangle
		{
			id: honorPanel
			Layout.fillWidth: true
			Layout.fillHeight: true
			color: "red"
			visible: true

			RowLayout
			{
				spacing: 10
				anchors.fill: parent;
				Button
				{
					id: honorButton10
					onClicked: this.background.color="#fff"
					Layout.fillWidth: true
					Layout.fillHeight: true

					contentItem: Text
					{
						text: "10"
						font.pixelSize: 55
						color: "black"
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
					}
					background: Rectangle
					{
						color: "#ccc"
						radius: 20
					}
				}

				Button
				{
					Layout.fillWidth: true
					Layout.fillHeight: true
					contentItem: Text
					{
						text: "11"
						font.pixelSize: 55
						color: "black"
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
					}
					background: Rectangle
					{
						color: "#ccc"
						radius: 20
					}
				}

				Button
				{
					Layout.fillWidth: true
					Layout.fillHeight: true
					contentItem: Text
					{
						text: "12"
						font.pixelSize: 55
						color: "black"
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
					}
					background: Rectangle
					{
						color: "#ccc"
						radius: 20
					}
				}
			}
		}

		Rectangle
		{
			id: bidPanel
			Layout.fillWidth: true
			Layout.fillHeight: true
			color: "black"
			visible: true
		}

		Rectangle
		{
			id: fatePanel
			Layout.fillWidth: true
			Layout.fillHeight: true
			color: "violet"
			visible: true
		}
	}
}
