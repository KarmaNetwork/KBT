message("Use ESP8266.cmake to build source code")

set (KBT_VAR_TOOLS_DIR ${CMAKE_BINARY_DIR}/tools)
file(MAKE_DIRECTORY ${KBT_VAR_TOOLS_DIR})

# Download toolchains for xtensa-lx106
file(GLOB KBT_VAR_FILE_EXISTS ${KBT_VAR_TOOLS_DIR}/xtensa-lx106-elf)
if(NOT KBT_VAR_FILE_EXISTS)
    message("Download toolchains from github")
    execute_process(COMMAND curl -L https://github.com/esp8266/Arduino/releases/download/2.3.0/linux64-xtensa-lx106-elf-gb404fb9.tgz
        COMMAND tar -zx WORKING_DIRECTORY ${KBT_VAR_TOOLS_DIR})
endif()

# Download sdk for ESP8266
set(KBT_ESP8266_SDK_VERSION 2.1.0)
file(GLOB KBT_VAR_FILE_EXISTS ${KBT_VAR_TOOLS_DIR}/ESP8266_NONOS_SDK-${KBT_ESP8266_SDK_VERSION})
if(NOT KBT_VAR_FILE_EXISTS)
    message("Download sdk from github")
    execute_process(COMMAND curl https://codeload.github.com/espressif/ESP8266_NONOS_SDK/tar.gz/v${KBT_ESP8266_SDK_VERSION}
        COMMAND tar -zx WORKING_DIRECTORY ${KBT_VAR_TOOLS_DIR})
endif()

set(CMAKE_SYSROOT ${CMAKE_BINARY_DIR}/tools/xtensa-lx106-elf)

set(tools ${CMAKE_SYSROOT})
set(CMAKE_C_COMPILER ${tools}/bin/xtensa-lx106-elf-gcc)
# set(CMAKE_CXX_COMPILER ${tools}/bin/xtensa-lx106-elf-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

link_directories(${KBT_VAR_TOOLS_DIR}/ESP8266_NONOS_SDK-${KBT_ESP8266_SDK_VERSION}/lib)
include_directories(${KBT_VAR_TOOLS_DIR}/ESP8266_NONOS_SDK-${KBT_ESP8266_SDK_VERSION}/include)

link_directories(${CMAKE_SYSROOT}/lib)
include_directories(${CMAKE_SYSROOT}/include)

enable_language(C)

