# CMakeLists.txt: Tools for handling plugins
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

# Convert a string to the filename it would have as a shared library.
function(make_plugin OUT IN)
	get_filename_component(DIR ${${IN}} DIRECTORY)
	if(NOT "${DIR}" STREQUAL "")
		set(DIR "${DIR}/")
	endif()
	get_filename_component(FNAME ${${IN}} NAME)
	set(FNAME "${CMAKE_SHARED_LIBRARY_PREFIX}${FNAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
	set(${OUT} "${DIR}${FNAME}" PARENT_SCOPE)
endfunction()

# Convert a list of strings to the file names each string would have
# as a shared library.
function(make_plugin_list OUT)
	set(${OUT})
	foreach(ITEM ${ARGN})
		make_plugin(ITEM ITEM)
		list(APPEND ${OUT} "${ITEM}")
	endforeach()
	set(${OUT} ${${OUT}} PARENT_SCOPE)
endfunction()
