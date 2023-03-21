# RP2040_SKELETON

# Setup

## Step 1: Setup directory layout
Create folder for application, which is created for you in this project as Code. Create subfolders include, lib and src under Code. (Also done for you.) 

## Step 2: Build logic
Examples taken from [this](https://github.com/daveythacher/LED_Matrix_RP2040).

### 2.1: Top level script for linux
Create file called build.sh with the following:
```bash
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
```
### 2.2: CMake top level
Create file called CMakeLists.txt in Code folder:
```CMake
cmake_minimum_required(VERSION 3.13)

# Pull in SDK (must be before project)
include(pico_sdk_import.cmake)

project(led C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
    
# Initialize the SDK
pico_sdk_init()

# create disassembly with source
function(pico_add_dis_output2 TARGET)
    add_custom_command(TARGET ${TARGET} POST_BUILD
        COMMAND ${CMAKE_OBJDUMP} -S $<TARGET_FILE:${TARGET}> >$<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>>,$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>,$<TARGET_PROPERTY:${TARGET},NAME>>.dis2)
    add_custom_command(TARGET ${TARGET} POST_BUILD
        COMMAND arm-none-eabi-size ${CMAKE_CURRENT_LIST_DIR}/../build/src/$<IF:$<BOOL:$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>>,$<TARGET_PROPERTY:${TARGET},OUTPUT_NAME>,$<TARGET_PROPERTY:${TARGET},NAME>>.elf
        VERBATIM
    )
endfunction()

add_subdirectory(lib)
add_subdirectory(src)
```
### 2.3: CMake lib folder
This folder would hold external module and libraries. In this example there are none. Only the pico-sdk will be here so there is nothing to do.

Create a file called CMakeLists.txt Code/lib folder:
```CMake

```
### 2.4: CMake src folder
Create a file called CMakeLists.txt Code/src folder:
```CMake
# add source files
add_executable(app
  main.cpp
)

# add include paths
target_include_directories(app PRIVATE
    ../include
)

# compiler flags
target_compile_options(app PRIVATE 
    $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
    -fno-exceptions 
    -fno-check-new 
    $<$<COMPILE_LANGUAGE:CXX>:-fno-enforce-eh-specs>
    -g 
    -ffunction-sections 
    -fdata-sections 
    -O3
    -funroll-loops 
    -Werror 
    -Wall
)

# preprocessor macros
target_compile_definitions(app PRIVATE 
    PICO_HEAP_SIZE=2048
    PICO_XOSC_STARTUP_DELAY_MULTIPLIER=64
)

# select linker script
pico_set_binary_type(app copy_to_ram)

# enable usb output, disable uart output
pico_enable_stdio_usb(app 1)
pico_enable_stdio_uart(app 0)

# create map/bin/hex file etc.
pico_add_extra_outputs(app)
pico_add_dis_output2(app)
  
# link in libraries (almost every hardware/<blah>.h or pico/<blah>.h is hardware_blah or pico_blah)
target_link_libraries(app 
    pico_runtime
    pico_multicore
    pico_stdlib
)

# linker options
target_link_options(app 
    PRIVATE "LINKER:--print-memory-usage"
)
```
## Step 3: PICO-SDK
Create submodule in Code/lib using git command below or by copying pico-sdk to Code/lib.
```bash
cd Code/lib
git submodule add https://github.com/raspberrypi/pico-sdk.git
cd ../..
```
## Step 4: Create optional setup script
Create the file setup.sh in top level directory. (Outside of Code)
``` bash
#!/bin/bash

sudo apt update
sudo apt install -y cmake git gcc-arm-none-eabi gcc g++ build-essential python3 doxygen graphviz
```

## Optional step: Keep git repo clean
Add the following to .gitignore:
```
Code/build/*
Code/pico_sdk_import.cmake
```

# Build
```bash
bash build.sh
```

File output files will be located in Code/build/src. (Files will be app.*)
