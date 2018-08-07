// main.cc: Entry point and program setup
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

#include <QGuiApplication>
#include <QQuickView>
#include <QQmlFileSelector>

const char* QML_FILE = "qrc:///main.qml";

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
	QQuickView view;
	view.connect(view.engine(), &QQmlEngine::quit, &app, &QCoreApplication::quit);

	auto throwaway = new QQmlFileSelector(view.engine(), &view);
	view.setSource(QUrl(QML_FILE));
	if (view.status() == QQuickView::Error)
		return -1;
	view.setResizeMode(QQuickView::SizeRootObjectToView);

	view.show();
	return app.exec();
}
