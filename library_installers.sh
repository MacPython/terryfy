#!/bin/bash
# Helper routines for building source libraries
# source this script to set up library building functions and vars
#
# You'll later need any relevant libraries stored at $ARCHIVE_PATH (see below)

# Get needed utilities
TERRYFY_DIR=`dirname "$BASH_SOURCE[0]}"`
source $TERRYFY_DIR/travis_tools.sh

# Compiler defaults
SYS_CC=clang
SYS_CXX=clang++
ARCH_FLAGS="-arch i386 -arch x86_64"
MACOSX_DEPLOYMENT_TARGET='10.6'

# Default location for source archives
SRC_ARCHIVES=archives

# Set BUILD_PREFIX elsewhere to change default
if [ -z "$BUILD_PREFIX" ]; then
    BUILD_PREFIX=$PWD/build
fi
SRC_PREFIX=$PWD/working
export PATH=$BUILD_PREFIX/bin:$PATH
export CPATH=$BUILD_PREFIX/include
export LIBRARY_PATH=$BUILD_PREFIX/lib
export PKG_CONFIG_PATH=$BUILD_PREFIX/lib/pkgconfig


function clean_builds {
    check_var $SRC_PREFIX
    check_var $BUILD_PREFIX
    rm -rf $SRC_PREFIX
    mkdir $SRC_PREFIX
    rm -rf $BUILD_PREFIX
    mkdir $BUILD_PREFIX
}


function clean_submodule {
    local submodule=$1
    check_var $submodule
    cd $submodule
    git clean -fxd
    git reset --hard
    cd ..
}


function standard_install {
    # Required arguments
    #  pkg_name (e.g. libpng)
    #  pkg_version (e.g. 1.6.12)
    #
    # Optional arguments
    #  archive_suffix (default .tar.gz)
    #  archive_prefix (default "$pkg_name-")
    #  extra_configures (default empty)
    #    This last can either be extra flags to pass to configure step, or the
    #    string "cmake" in which case use cmake for configure step
    local pkg_name=$1
    check_var $pkg_name
    local pkg_version=$2
    check_var $pkg_version
    local archive_suffix=$3
    if [ -z "$archive_suffix" ]; then
        archive_suffix=.tar.gz
    fi
    local archive_prefix=$4
    if [ -z "$archive_prefix" ]; then
        archive_prefix="${pkg_name}-"
    fi
    # Put the rest of the positional parameters into new positional params
    set -- "${@:5:$#-4}"
    echo "$@"
    check_var $SRC_PREFIX
    check_var $BUILD_PREFIX
    local archive_path="$SRC_ARCHIVES/${archive_prefix}${pkg_version}${archive_suffix}"
    tar xvf $archive_path -C $SRC_PREFIX
    cd $SRC_PREFIX/$pkg_name-$pkg_version
    require_success "Failed to cd to $pkg_name directory"
    if [ "$1" == "cmake" ]; then # cmake configure
        CC=${SYS_CC} CXX=${SYS_CXX} CFLAGS=$ARCH_FLAGS \
            CMAKE_INCLUDE_PATH=$CPATH \
            CMAKE_LIBRARY_PATH=$LIBRARY_PATH \
            cmake -DCMAKE_INSTALL_PREFIX:PATH=$BUILD_PREFIX .
    else # standard configure
        CC=${SYS_CC} CXX=${SYS_CXX} CFLAGS=$ARCH_FLAGS ./configure \
            --prefix=$BUILD_PREFIX "$@"
    fi
    make
    make install
    require_success "Failed to install $pkg_name $pkg_version"
    cd ../..
}
