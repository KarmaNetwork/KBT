set (KBT_VAR_BRANCH command)
set (KBT_VAR_TOOLS_DIR ${CMAKE_BINARY_DIR}/KBT-${KBT_VAR_BRANCH})
file(GLOB KBT_VAR_FILE_EXISTS ${KBT_VAR_TOOLS_DIR})
if(NOT KBT_VAR_FILE_EXISTS)
    message("Download full KBT library from github")
    execute_process(COMMAND curl https://codeload.github.com/tiannian/KBT/tar.gz/${KBT_VAR_BRANCH} 
        COMMAND tar -zx)
endif()
include(${KBT_VAR_TOOLS_DIR}/LibKBT.cmake)
