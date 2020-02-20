#!/bin/bash

function ErrorExit() {
    echo "[ERROR] Failed to run script (line: ${BASH_LINENO[0]})" >&2
    exit 1;
}

CC='gcc'
CXX='g++'
GOOGLETEST_VERSION='release-1.10.0'
googletestDir='./googletest'
includeDir='./include'
libDir='./lib'

if [ ! -d $includeDir ]; then
    mkdir $includeDir
fi
if [ ! -d $libDir ]; then
    mkdir $libDir
fi

if [ -d $googletestDir ]; then
    rm -rf $googletestDir
fi
git clone https://github.com/google/googletest.git || ErrorExit

cd  $googletestDir || ErrorExit
git checkout $GOOGLETEST_VERSION || ErrorExit
mkdir build && cd build || ErrorExit
(CC=$CC CXX=$CXX cmake ..) || ErrorExit
make || ErrorExit
cd ../../ || ErrorExit

# ATTENSION:
# Build modules path depends on GOOGLETEST_VERSION.
# You should change the following script as necessary.
cp -r $googletestDir/google{test,mock}/include/* $includeDir/ || ErrorExit
cp $googletestDir/build/lib/* $libDir/ || ErrorExit
