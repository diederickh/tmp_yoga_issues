#!/bin/sh
d=${PWD}
bd=${d}/../
sd=${bd}/src/
id=${bd}/install
ed=${d}/../
rd=${d}/../reference/
d=${PWD}
is_debug="n"
build_dir="build_unix"
cmake_build_type="Release"
cmake_config="Release"
debug_flag=""
debugger=""
cmake_generator=""

# Detect OS.
if [ "$(uname)" == "Darwin" ]; then
    if [ "${cmake_generator}" = "" ] ; then
        cmake_generator="Unix Makefiles"
    fi
    os="mac"
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    if [ "${cmake_generator}" = "" ] ; then
        cmake_generator="Unix Makefiles"
    fi
    os="linux"
else
    if [ "${cmake_generator}" = "" ] ; then
        cmake_generator="Visual Studio 14 2015 Win64"
        build_dir="build_vs2015"
    fi
    os="win"
fi

# Detect Command Line Options
for var in "$@"
do
    if [ "${var}" = "debug" ] ; then
        is_debug="y"
        cmake_build_type="Debug"
        cmake_config="Debug"
        debug_flag="_debug"
        debugger="lldb"
    elif [ "${var}" = "xcode" ] ; then
        build_dir="build_xcode"
        cmake_generator="Xcode"
        build_dir="build_xcode"
    fi
done

# Create unique name for this build type.
bd="${d}/${build_dir}.${cmake_build_type}"

if [ ! -d ${bd} ] ; then 
    mkdir ${bd}
fi

# Compile the library.
cd ${bd}

# Simple function which compiles the library
# for different architectures.
function build() {

    arch=$1

    if [ "${arch}" != "" ] ; then 
        arch_bd="${bd}.${arch}"
        arch_id=${id}/${arch}

        echo "BUILDING FOR: ${arch}"
        
        if [ ! -d ${arch_bd} ] ; then
            mkdir ${arch_bd}
        fi

        cd ${arch_bd}
        cmake -DCMAKE_INSTALL_PREFIX=${arch_id} \
              -DCMAKE_BUILD_TYPE=${cmake_build_type} \
              -DCMAKE_TOOLCHAIN_FILE="${d}/${arch}.cmake" \
              -G "${cmake_generator}" \
              ..

        if [ $? -ne 0 ] ; then
            echo "Failed to configure"
            exit
        fi
    else
        cmake -DCMAKE_INSTALL_PREFIX=${id} \
              -DCMAKE_BUILD_TYPE=${cmake_build_type} \
              -G "${cmake_generator}" \
              ..

    fi
    
    cmake --build . --target install --config ${cmake_build_type}

    if [ $? -ne 0 ] ; then
        echo "Failed to build"
        exit
    fi
}

# Combines the multi-arch / fat libraries
function create_fat_lib() {
    libname=${1}
    lipo -create \
         "${id}/ios.armv7/lib/${libname}.a" \
         "${id}/ios.armv7s/lib/${libname}.a" \
         "${id}/ios.arm64/lib/${libname}.a" \
         "${id}/ios.simulator64/lib/${libname}.a" \
         "${id}/ios.i386/lib/${libname}.a" \
         -output \
         "${id}/lib/${libname}.a"
}

if [ "${os}" = "mac" ] ; then
    build "macos.x86_64"
else
    build
fi

if [ "${os}" = "mac" ] ; then
    cd ${id}/macos.x86_64/bin
    ${debugger} ./test_yoga${debug_flag}
else
    cd ${id}/bin
fi
