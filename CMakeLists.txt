# CMakeLists.txt: Build Script
# Copyright 2018 Vincent Damewood
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.12.0)

include("cmake/plugintools.cmake")

###################
# Project Details #
###################

project(Chikara
	VERSION      "0.0.0"
	DESCRIPTION  "Accessibility for a card game"
	HOMEPAGE_URL "http://vdamewood.com/projects/chikara"
	LANGUAGES    "CXX")

set(VENDOR       "Vincent Damewood")
set(COPYRIGHT    "Copyrghit 2018 Vincent Damewood")
set(UPGRADE_GUID "76D08E10-64EF-44C9-B3C0-52C879D1B18A")

set(EXECUTABLE ${CMAKE_PROJECT_NAME})
set(HEADERS )
set(SOURCES main.cc)

set(MOC_HEADERS )
set(QRCS Chikara.qrc)

set(QT_PLUGINS
)
set(QML_PLUGINS
	QtQuick.2/qtquick2plugin
	QtQuick/Controls.2/qtquickcontrols2plugin
	QtQuick/Templates.2/qtquicktemplates2plugin
	QtQuick/Window.2/windowplugin
)
set(QML_FILES
	QtQuick.2/qmldir
	QtQuick/Controls.2/qmldir
	QtQuick/Controls.2/ApplicationWindow.qml
	QtQuick/Controls.2/Button.qml
	QtQuick/Templates.2/qmldir
	QtQuick/Window.2/qmldir
)

#######################
# Dependency Searches #
#######################

find_package(Qt5Quick REQUIRED)

###############
# Build Setup #
###############

include_directories(${Qt5Quick_INCLUDE_DIRS})

list(TRANSFORM HEADERS     PREPEND "src/")
list(TRANSFORM MOC_HEADERS PREPEND "src/")
list(TRANSFORM SOURCES     PREPEND "src/")
list(TRANSFORM QRCS        PREPEND "src/")

if(MOC_HEADERS)
	qt5_wrap_cpp(TMP ${MOC_HEADERS})
	list(APPEND SOURCES ${TMP})
	set(TMP)
endif()

if(QRCS)
	qt5_add_resources(TMP ${QRCS})
	list(APPEND SOURCES ${TMP})
	set(TMP)
endif()

if (APPLE)
	list(APPEND QT_PLUGINS "platforms/qcocoa")
elseif(WIN32)
	list(APPEND QT_PLUGINS "platforms/qwindows")
endif()

if(APPLE OR WIN32)
	set(PREPARE_BUNDLE ON)
	make_plugin_list(QT_PLUGIN_LIBS ${QT_PLUGINS})
	make_plugin_list(QML_PLUGIN_LIBS ${QML_PLUGINS})

	set(FIXUP_PLUGINS ${QT_PLUGIN_LIBS})
else()
	set(PREPARE_BUNDLE OFF)
endif()

if(APPLE)
	set(RUNTIME_INSTALL_PATH    bin)
	set(BUNDLE_INSTALL_PATH     .)
	set(DOC_INSTALL_PATH        .)

	set(FIXUP_APP "\${CMAKE_INSTALL_PREFIX}/${EXECUTABLE}.app")
	foreach(P ${QML_PLUGIN_LIBS})
		get_filename_component(F ${P} NAME)
		list(APPEND FIXUP_PLUGINS "quick/${F}")
	endforeach()
	list(TRANSFORM FIXUP_PLUGINS PREPEND "${FIXUP_APP}/Contents/PlugIns/")

	get_target_property(QT_LIB_DIR Qt5::Quick LOCATION)
	get_filename_component(QT_LIB_DIR ${QT_LIB_DIR} PATH)
	get_filename_component(QT_LIB_DIR "${QT_LIB_DIR}/.." ABSOLUTE)
	get_filename_component(QT_DIR "${QT_LIB_DIR}/.." ABSOLUTE)

	list(APPEND SOURCES "src/qt.conf")
	set_source_files_properties("src/qt.conf"
		PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

	foreach(P ${QT_PLUGIN_LIBS})
		get_filename_component(D ${P} DIRECTORY)
		list(APPEND SOURCES "${QT_DIR}/plugins/${P}")
		set_source_files_properties("${QT_DIR}/plugins/${P}"
			PROPERTIES MACOSX_PACKAGE_LOCATION "PlugIns/${D}")
	endforeach()

	foreach(P ${QML_PLUGIN_LIBS})
		list(APPEND SOURCES "${QT_DIR}/qml/${P}")
		set_source_files_properties("${QT_DIR}/qml/${P}"
			PROPERTIES MACOSX_PACKAGE_LOCATION "PlugIns/quick")
	endforeach()

	foreach(P ${QML_FILES})
		get_filename_component(D ${P} DIRECTORY)
		list(APPEND SOURCES "${QT_DIR}/qml/${P}")
		set_source_files_properties("${QT_DIR}/qml/${P}"
			PROPERTIES MACOSX_PACKAGE_LOCATION "Resources/qml/${D}")
	endforeach()
elseif(WIN32)
	set(RUNTIME_INSTALL_PATH    .)
	set(BUNDLE_INSTALL_PATH		Error)
	set(DOC_INSTALL_PATH        .)

	set(FIXUP_APP "\${CMAKE_INSTALL_PREFIX}/${EXECUTABLE}.exe")
	list(APPEND FIXUP_PLUGINS ${QML_PLUGIN_LIBS})
	list(TRANSFORM FIXUP_PLUGINS PREPEND "\${CMAKE_INSTALL_PREFIX}/")

	get_target_property(QT_DIR Qt5::Quick LOCATION)
	get_filename_component(QT_DIR ${QT_DIR} PATH)
	get_filename_component(QT_DIR "${QT_DIR}/.." ABSOLUTE)
else()
	set(RUNTIME_INSTALL_PATH    bin)
	set(BUNDLE_INSTALL_PATH     share/${CMAKE_PROJECT_NAME}/error)
	set(DOC_INSTALL_PATH        share/${CMAKE_PROJECT_NAME}/doc)
endif()

###########
# Targets #
###########

add_executable(${EXECUTABLE} WIN32 MACOSX_BUNDLE ${SOURCES})
target_link_libraries(${EXECUTABLE} ${Qt5Quick_LIBRARIES})

if(APPLE)
	set(PLUGIN_DIR ${CMAKE_BINARY_DIR}/${EXECUTABLE}.app/Contents/PlugIns)
	set(RESOURCE_DIR ${CMAKE_BINARY_DIR}/${EXECUTABLE}.app/Contents/Resources)

	foreach(P ${QML_PLUGIN_LIBS})
		get_filename_component(D ${P} DIRECTORY)
		get_filename_component(F ${P} NAME)
		file(RELATIVE_PATH QUICK_DIR "${RESOURCE_DIR}/qml/${D}" "${PLUGIN_DIR}/quick")
		add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
			COMMAND ${CMAKE_COMMAND} -E create_symlink
				"${QUICK_DIR}/${F}"
				"${RESOURCE_DIR}/qml/${P}"
	)
	endforeach()

	set_target_properties(${EXECUTABLE} PROPERTIES
		INSTALL_RPATH ${QT_LIB_DIR}
		#MACOSX_BUNDLE_INFO_STRING
		#MACOSX_BUNDLE_ICON_FILE
		#MACOSX_BUNDLE_GUI_IDENTIFIER
		#MACOSX_BUNDLE_LONG_VERSION_STRING
		MACOSX_BUNDLE_BUNDLE_NAME			${CMAKE_PROJECT_NAME}
		#MACOSX_BUNDLE_SHORT_VERSION_STRING
		#MACOSX_BUNDLE_BUNDLE_VERSION
		#MACOSX_BUNDLE_COPYRIGHT
		)
endif()

################
# Installation #
################

install(
	FILES Readme.md License.txt
	DESTINATION ${DOC_INSTALL_PATH})

install(TARGETS ${EXECUTABLE}
	RUNTIME DESTINATION ${RUNTIME_INSTALL_PATH}
	BUNDLE	DESTINATION ${BUNDLE_INSTALL_PATH}
)
if(PREPARE_BUNDLE)
	if (WIN32)
		foreach(P ${QT_PLUGIN_LIBS})
			get_filename_component(D ${P} DIRECTORY)
			install(CODE "FILE(INSTALL ${QT_DIR}/plugins/${P} DESTINATION \"\${CMAKE_INSTALL_PREFIX}/${D}\")")
		endforeach()
		foreach(P ${QML_PLUGIN_LIBS})
			get_filename_component(D ${P} DIRECTORY)
			install(CODE "FILE(INSTALL ${QT_DIR}/qml/${P} DESTINATION \"\${CMAKE_INSTALL_PREFIX}/${D}\")")
		endforeach()
		foreach(F ${QML_FILES})
			get_filename_component(D ${F} DIRECTORY)
			install(CODE "FILE(INSTALL ${QT_DIR}/qml/${F} DESTINATION \"\${CMAKE_INSTALL_PREFIX}/${D}\")")
		endforeach()
	endif()

	install(CODE "include(BundleUtilities)")
	install(CODE "fixup_bundle(\"${FIXUP_APP}\" \"${FIXUP_PLUGINS}\" \"\")")
	install(CODE "file(REMOVE \"\${CMAKE_INSTALL_PREFIX}/VCRUNTIME140.dll\")")
endif()

####################
# Package Creation #
####################

set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
set(CPACK_PACKAGE_VENDOR "${VENDOR}")
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")

set(CPACK_STRIP_FILES On)
set(CPACK_VERBATIM_VARIABLES Off)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
set(CPACK_SOURCE_STRIP_FILES Off)
set(CPACK_SOURCE_GENERATOR TXZ)
set(CPACK_SOURCE_IGNORE_FILES
	"/\\\\.git/"
	"/\\\\.gitignore"
	"/[Bb]uild.*/"
	"\\\\.DS_Store"
	".*\\\\.code-workspace"
	"\\\\.vscode"
)

set(CPACK_PACKAGE_EXECUTABLES ${EXECUTABLE} ${PROJECT_NAME})
if(APPLE)
  set(CPACK_GENERATOR ZIP DragNDrop)
  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-macOS")
  set(CPACK_DMG_VOLUME_NAME "${PROJECT_NAME}")
  set(CPACK_DMG_FORMAT UDZO)
  set(CPACK_DMG_DISABLE_APPLICATIONS_SYMLINK On)
elseif(WIN32)
  if(MSVC)
    set(CPACK_GENERATOR ZIP WIX)
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/cpack/WixLicense.txt")
    set(CPACK_WIX_UPGRADE_GUID ${UPGRADE_GUID})
	#This doesn't work quite right:
	#set(CPACK_WIX_PATCH_FILE "${CMAKE_SOURCE_DIR}/cpack/WixPatch.xml")
  else()
    set(CPACK_GENERATOR ZIP)
  endif()
  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-Windows")
else()
  set(CPACK_GENERATOR TXZ)
  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}")
endif()
set(BIN_PACKAGE "${CPACK_PACKAGE_FILE_NAME}" CACHE "Filename for package" INTERNAL)
set(SRC_PACKAGE "${PROJECT_NAME}-${PROJECT_VERSION}" CACHE "Filename for source package" INTERNAL)
include(CPack)
