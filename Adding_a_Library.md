# Setup
## Step 1: Setup main project
Follow steps in Project_Setup.md
## Step 2: Add or make the library
### Step 2.1: Manual code library
Create unique folder under Code/lib. (The resulting path would be Code/lib/<folder name>) Add any and all source code files to this folder.
### Step 2.2: Git submodule library
Add the submodule using the following commands:
``` bash
cd Code/lib
git submodule add <url to submodule>
cd ../..
```
## Step 3: Add the library to the project
Add the following to the Code/lib/CMakeLists.txt:
```
add_subdirectory(<folder name>)
```
Note pico-sdk is in Code/lib but cannot be included. Every other folder should be.
## Step 4: Create the build logic
In the library we need to create the build logic in CMake. There are three types of libraries which you can create. This will show you how to create an interface library which will be compiled as if it is part of the main binary.

Create a file called Code/lib/\<folder name\>/CMakeLists.txt with the following contents:
```
# It is not recommended to build dynamic libraries.
add_library(lib INTERFACE)

target_sources(lib INTERFACE
    lib.cpp
)

# For interface libraries this is not completely required. (This would likely be required for static and dynamic libraries.)
# Use caution when building static libraries as there could be internal dependencies which need to be mitigated.
target_link_libraries(lib INTERFACE
    pico_multicore
    hardware_dma
    hardware_pio
    hardware_timer
)
```
Note if the file already exists or this project is a submodule with a CMakeLists.txt you may need to remove or modify it. For a submodule this may involve a forking the submodule and making modify the CMakeLists.txt at the top level. If this is done correctly you should still be capable of pulling in updates via cherry picking, however this is advanced. A pull and merge is likely to work in most cases and this is preferred.
  
## Step 5: Link library to main binary
Add the following to Code/src/CMakeLists.txt, inside the target_link_libraries:
```
  lib
```
  
