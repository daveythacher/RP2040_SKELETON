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