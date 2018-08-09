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
set(QRCS main.qrc)

set(QT_PLUGINS
)
set(QML_PLUGINS
	QtQuick.2/qtquick2plugin
)
set(QML_FILES
	QtQuick.2/qmldir
)


#######################
# Dependency Searches #
#######################

find_package(Qt5Quick REQUIRED)

######################
# Derrivative Values #
######################

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

if(APPLE)
	set(RUNTIME_INSTALL_PATH    bin)
	set(BUNDLE_INSTALL_PATH     .)
	set(SHARE_INSTALL_PATH      Error)
	set(DOC_INSTALL_PATH        .)

	set(PREPARE_BUNDLE ON)
	set(BUNDLE_EXECUTABLE "\${CMAKE_INSTALL_PREFIX}/${EXECUTABLE}.app")
	set(BUNDLE_PLUGIN_DIR "${BUNDLE_EXECUTABLE}/Contents/PlugIns/")
	set(BUNDLE_QML_DIR "\${CMAKE_INSTALL_PREFIX}/${EXECUTABLE}.app/Contents/Resources/qml")

	get_target_property(QT_RPATH Qt5::Quick LOCATION)
	get_filename_component(QT_RPATH ${QT_RPATH} PATH)
	get_filename_component(QT_RPATH "${QT_RPATH}/.." ABSOLUTE)
	get_filename_component(QTDIR "${QT_RPATH}/.." ABSOLUTE)

	list(APPEND SOURCES src/qt.conf)
	set_source_files_properties(src/qt.conf
		PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

	# FIXME: This and the POST_BUILD symlink below should be done from a
	# list of plugins above in the project details section.
	list(APPEND QT_PLUGINS "platforms/qcocoa")

	make_plugin_list(PLUGIN_LIBS ${QT_PLUGINS})
	set(PLUGINS ${PLUGIN_LIBS})
	foreach(P ${PLUGIN_LIBS})
		list(APPEND SOURCES "${QTDIR}/plugins/${P}")
		get_filename_component(D ${P} DIRECTORY)
		set_source_files_properties("${QTDIR}/plugins/${P}"
			PROPERTIES MACOSX_PACKAGE_LOCATION "PlugIns/${D}")
	endforeach()

	# FIXME: Need to symlink Resources/qml/P --> PlugIns/Quick
	make_plugin_list(QMLPLUGIN_LIBS ${QML_PLUGINS})
	foreach(P ${QMLPLUGIN_LIBS})
		list(APPEND SOURCES "${QTDIR}/qml/${P}")
		get_filename_component(N ${P} NAME)
		list(APPEND PLUGINS "quick/${N}")
		set_source_files_properties("${QTDIR}/qml/${P}"
			PROPERTIES MACOSX_PACKAGE_LOCATION "PlugIns/quick")
	endforeach()

	foreach(P ${QML_FILES})
		list(APPEND SOURCES "${QTDIR}/qml/${P}")
		get_filename_component(D ${P} DIRECTORY)
		set_source_files_properties("${QTDIR}/qml/${P}"
			PROPERTIES MACOSX_PACKAGE_LOCATION "Resources/qml/${D}")
	endforeach()

	list(TRANSFORM PLUGINS PREPEND "${BUNDLE_PLUGIN_DIR}")
	message("${PLUGINS}")
elseif(WIN32)
	set(RUNTIME_INSTALL_PATH    .)
	set(BUNDLE_INSTALL_PATH		Error)
	set(SHARE_INSTALL_PATH      .)
	set(DOC_INSTALL_PATH        .)

	get_target_property(QT_RPATH Qt5::Quick LOCATION)
	get_filename_component(QT_RPATH ${QT_RPATH} PATH)
	get_filename_component(QTDIR "${QT_RPATH}/.." ABSOLUTE)

	set(PREPARE_BUNDLE ON)
	set(BUNDLE_EXECUTABLE "\${CMAKE_INSTALL_PREFIX}/${EXECUTABLE}.exe")
	set(BUNDLE_QML_DIR    "\${CMAKE_INSTALL_PREFIX}")
	set(BUNDLE_PLUGIN_DIR "\${CMAKE_INSTALL_PREFIX}")

	# FIXME: Do Windows Bundle Prep
else()
	set(RUNTIME_INSTALL_PATH    bin)
	set(BUNDLE_INSTALL_PATH     share/${CMAKE_PROJECT_NAME}/error)
	set(SHARE_INSTALL_PATH      share/${CMAKE_PROJECT_NAME})
	set(DOC_INSTALL_PATH        share/${CMAKE_PROJECT_NAME}/doc)

	set(PREPARE_BUNDLE OFF)
endif()

###########
# Targets #
###########

add_executable(${EXECUTABLE} WIN32 MACOSX_BUNDLE ${SOURCES})
target_link_libraries(${EXECUTABLE} ${Qt5Quick_LIBRARIES})

if(APPLE)
	set(RESOURCE_DIR ${CMAKE_BINARY_DIR}/${EXECUTABLE}.app/Contents/Resources)
	set(QUICK_DIR "../../../PlugIns/quick")
	add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E create_symlink
			"${QUICK_DIR}/libqtquick2plugin.dylib"
			"${RESOURCE_DIR}/qml/QtQuick.2/libqtquick2plugin.dylib"
	)
	set_target_properties(${EXECUTABLE} PROPERTIES
		INSTALL_RPATH ${QT_RPATH}
		#MACOSX_BUNDLE_INFO_STRING
		#MACOSX_BUNDLE_ICON_FILE
		#MACOSX_BUNDLE_GUI_IDENTIFIER
		#MACOSX_BUNDLE_LONG_VERSION_STRING
		MACOSX_BUNDLE_BUNDLE_NAME			${CMAKE_PROJECT_NAME}
		#MACOSX_BUNDLE_SHORT_VERSION_STRING
		#MACOSX_BUNDLE_BUNDLE_VERSION
		#MACOSX_BUNDLE_COPYRIGHT
		)
elseif(WIN32)
		#set(PREPARE_BUNDLE ON)
		#set(BUNDLE_EXECUTABLE "\${CMAKE_INSTALL_PREFIX}/${EXECUTABLE}.exe")
		#set(BUNDLE_PLUGIN_DIR "\${CMAKE_INSTALL_PREFIX}")
else()
		set(PREPARE_BUNDLE OFF)
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
	# FIXME: This should be done based on input specified in the
	# project details section.
	if (WIN32)
		install(CODE "FILE(INSTALL ${QTDIR}/plugins/platforms/qwindows.dll   DESTINATION \"${BUNDLE_PLUGIN_DIR}/platforms\")")
		install(CODE "FILE(INSTALL ${QTDIR}/qml/QtQuick.2/qtquick2plugin.dll DESTINATION \"${BUNDLE_QML_DIR}/QtQuick.2\")")
		install(CODE "FILE(INSTALL ${QTDIR}/qml/QtQuick.2/qmldir             DESTINATION \"${BUNDLE_QML_DIR}/QtQuick.2\")")

		set(PLUGINS platforms/qwindows.dll)

		list(TRANSFORM PLUGINS PREPEND "${BUNDLE_PLUGIN_DIR}/")
	endif()

	#foreach(PLUGIN_TARGET ${Qt5Gui_PLUGINS})
	#	get_target_property(PLUGIN_ABSOLUTE_PATH ${PLUGIN_TARGET} LOCATION)
	#	string(FIND "${PLUGIN_ABSOLUTE_PATH}" "plugins/" INDEX REVERSE)
	#	math(EXPR INDEX "${INDEX} + 8")
	#	string(SUBSTRING ${PLUGIN_ABSOLUTE_PATH} ${INDEX} -1 PLUGIN_RELATIVE_PATH)
	#	string(FIND ${PLUGIN_RELATIVE_PATH} "/" INDEX REVERSE)
	#	string(SUBSTRING ${PLUGIN_RELATIVE_PATH} 0 ${INDEX} PLUGIN_RELATIVE_DIR)

	#	install(CODE "FILE(INSTALL ${PLUGIN_ABSOLUTE_PATH} DESTINATION \"${BUNDLE_PLUGIN_DIR}/${PLUGIN_RELATIVE_DIR}\")")
	#	list(APPEND PLUGINS "${BUNDLE_PLUGIN_DIR}/${PLUGIN_RELATIVE_PATH}")
	#endforeach()

	install(CODE "include(BundleUtilities)")
	install(CODE "fixup_bundle(\"${BUNDLE_EXECUTABLE}\" \"${PLUGINS}\" \"\")")
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
	"/\\.git/"
	"/\\.gitignore"
	"/[Bb]uild.*/"
	"\\.DS_Store"
	".*\\.code-workspace"
	"\\.vscode"
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
	set(CPACK_WIX_PATCH_FILE "${CMAKE_SOURCE_DIR}/cpack/WixPatch.xml")
  else()
    set(CPACK_GENERATOR ZIP)
  endif()
  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-Windows")
else()
  set(CPACK_GENERATOR TXZ)
  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}")
endif()
include(CPack)
