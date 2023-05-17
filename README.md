# RP2040_SKELETON
This is a skeleton project which is intended to help people with CMake. Follow the steps outlined in [Project Setup](Project_Setup.md) to get started with RP2040 development using PICO-SDK. This tutorial is in no way complete, but should serve as a lanuching point for beginners. Google and forums should be able to help with more advanced usages. The discussions feature of this repository is available also.

To add a library follow the steps outlined in [Adding a Library](Adding_a_Library.md). These steps work for git submodules and raw code libraries/modules. Note submodules allow cleaner versioning and code license management. These steps only show how to build a CMake interface library, however building a static library is very similar. Interface libraries are recommended for beginners as static libraries come with certain complexities. The overall benefit of static libraries is small for most usuages, but they do exist.

Warning: Here are some of the areas which are not fully explained. (That I can think of right now.)
```
    Libraries (internal and external)
    Linking libraries in CMake
    Linker script and flags
    Multiple executables (not really common)
    Preprocessor macros and compiler flags
```

Once the setup steps have been completed, you should be able to compile with one command:
``` bash
bash build.sh
```
In the case of this example a blink example binary will be created called Code/build/src/app.uf2


Note this tutorial is written for Linux, however all the CMake logic should work on Windows, MAC, etc.
