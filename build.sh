#!/bin/sh
git submodule update --init
cd Code/lib/pico-sdk/
git submodule update 
export PICO_SDK_PATH=$PWD
cd ../..
mkdir build
cp ./lib/pico-sdk/external/pico_sdk_import.cmake .
cd build
cmake ..
make -j $(($(nproc) * 2))