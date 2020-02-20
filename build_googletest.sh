#!/bin/bash

function ErrorExit() {
    echo "[ERROR] Failed to run script (line: ${BASH_LINENO[0]})" >&2
    exit 1;
}

CC='gcc'
CXX='g++'
includeDir='./include'
libDir='./lib'

if [ ! -d $includeDir ]; then
    mkdir $includeDir
fi
if [ ! -d $libDir ]; then
    mkdir $libDir
fi

git submodule init || ErrorExit
git submodule update || ErrorExit

cd googletest || ErrorExit
if [ -d build ]; then
    rm -rf build || ErrorExit
fi
mkdir build || ErrorExit
cd build || ErrorExit
(CC=$CC CXX=$CXX cmake ..) || ErrorExit
make || ErrorExit
cd ../../ || ErrorExit

# ATTENSION:
# Build modules path depends on GOOGLETEST_VERSION.
# You should change the following script as necessary.
cp -r googletest/google{test,mock}/include/* $includeDir/ || ErrorExit
cp googletest/build/lib/* $libDir/ || ErrorExit
