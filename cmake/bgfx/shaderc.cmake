# bgfx.cmake - bgfx building in cmake
# Written in 2017 by Joshua Brookover <joshua.al.brookover@gmail.com>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Grab the shaderc source files
file(
	GLOB
	SHADERC_SOURCES #
	${BGFX_DIR}/tools/shaderc/*.cpp #
	${BGFX_DIR}/tools/shaderc/*.h #
	${BGFX_DIR}/src/shader* #
)

add_library(shaderclib STATIC ${SHADERC_SOURCES})

target_link_libraries(
	shaderclib
	PRIVATE bx
			bgfx-vertexlayout
			fcpp
			glslang
			glsl-optimizer
			spirv-opt
			spirv-cross
)
target_link_libraries(
	shaderclib
	PRIVATE bx
			bimg
			bgfx-vertexlayout
			fcpp
			glslang
			glsl-optimizer
			spirv-opt
			spirv-cross
			webgpu
)

if(BGFX_AMALGAMATED)
	target_link_libraries(shaderclib PRIVATE bgfx-shader)
endif()

set_target_properties(
	shaderclib PROPERTIES FOLDER "bgfx/tools" #
					   OUTPUT_NAME ${BGFX_TOOLS_PREFIX}shaderclib #
)

add_executable(
	shaderc
)

target_link_libraries(
	shaderc
	PRIVATE 
			shaderclib 
			bimg 
			bgfx-vertexlayout 
			bgfx-shader
)

if(BGFX_BUILD_TOOLS_SHADER)
	add_executable(bgfx::shaderc ALIAS shaderc)
	if(BGFX_CUSTOM_TARGETS)
		add_dependencies(tools shaderc)
	endif()
endif()

if(ANDROID)
	target_link_libraries(shaderc PRIVATE log)
elseif(IOS)
	set_target_properties(shaderc PROPERTIES MACOSX_BUNDLE ON MACOSX_BUNDLE_GUI_IDENTIFIER shaderc)
endif()

add_library( shadercdyn 
	SHARED 
	${CMAKE_SOURCE_DIR}/shaderlib.cpp )
set_target_properties( shadercdyn 
	PROPERTIES FOLDER "bgfx/tools" )
set_target_properties( shadercdyn 
	PROPERTIES PUBLIC_HEADER "${BGFX_DIR}/tools/shaderc/shaderc.h;${BGFX_DIR}/src/vertexlayout.h")
target_link_libraries(shadercdyn 
	PRIVATE shaderclib bimg bgfx-vertexlayout bgfx-shader )

if(BGFX_INSTALL)
	install(TARGETS shaderc EXPORT "${TARGETS_EXPORT_NAME}" DESTINATION "${CMAKE_INSTALL_BINDIR}")
	install(TARGETS shadercdyn EXPORT "${TARGETS_EXPORT_NAME}")
endif()
