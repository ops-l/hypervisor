#
# Bareflank Hypervisor
# Copyright (C) 2015 Assured Information Security, Inc.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

set(GSL_INTERM_INSTALL_DIR ${BF_BUILD_DEPENDS_DIR}/gsl/install)

list(APPEND GSL_CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX=${GSL_INTERM_INSTALL_DIR}
    -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_PATH_GSL}
    -DCMAKE_INSTALL_MESSAGE=LAZY
)

ExternalProject_Add(
    gsl
    GIT_REPOSITORY      https://github.com/Bareflank/GSL.git
    GIT_TAG             v1.2
    GIT_SHALLOW         1
    CMAKE_ARGS          ${GSL_CMAKE_ARGS}
    PREFIX              ${BF_BUILD_DEPENDS_DIR}/gsl
    SOURCE_DIR          ${BF_BUILD_DEPENDS_DIR}/gsl/src
    BINARY_DIR          ${BF_BUILD_DEPENDS_DIR}/gsl/build
    INSTALL_DIR         ${BF_BUILD_DEPENDS_DIR}/gsl/install
    TMP_DIR             ${BF_BUILD_DEPENDS_DIR}/gsl/tmp
    STAMP_DIR           ${BF_BUILD_DEPENDS_DIR}/gsl/stamp
)

if(NOT EXISTS ${BUILD_SYSROOT_OS}/include/gsl)
    ExternalProject_Add_Step(
        gsl
        gsl_os_sysroot_install
        COMMAND 			${CMAKE_COMMAND} -E copy_directory ${GSL_INTERM_INSTALL_DIR}/include ${BUILD_SYSROOT_OS}/include
        DEPENDEES install
    )
endif()

if(NOT EXISTS ${BUILD_SYSROOT_VMM}/include/gsl AND ${BUILD_VMM})
    ExternalProject_Add_Step(
        gsl
        gsl_vmm_sysroot_install
        COMMAND 			${CMAKE_COMMAND} -E copy_directory ${GSL_INTERM_INSTALL_DIR}/include ${BUILD_SYSROOT_VMM}/include
        DEPENDEES install
    )
endif()