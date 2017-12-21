set (KBT_VAR_BRANCH command)
set (KBT_VAR_TOOLS_DIR ${CMAKE_BINARY_DIR}/KBT-${KBT_VAR_BRANCH})

execute_process(COMMAND curl https://codeload.github.com/tiannian/KBT/tar.gz/command 
                COMMAND tar -zxv)
include(${KBT_VAR_TOOLS_DIR}/LibKBT.cmake)
