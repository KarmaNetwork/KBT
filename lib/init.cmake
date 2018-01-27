# variable declare
# KBT_VAR_SOURCE_DIR
# KBT_VAR_TOOLS_DIR
# KBT_VAR_PROJECT_NAME

# create some directory
file(MAKE_DIRECTORY ${KBT_VAR_SOURCE_DIR}/src
    ${KBT_VAR_SOURCE_DIR}/dependenices
    ${KBT_VAR_SOURCE_DIR}/test
    ${KBT_VAR_SOURCE_DIR}/include)

# copy gitignore file
file(COPY ${KBT_VAR_TOOLS_DIR}/.gitignore DESTINATION ${KBT_VAR_SOURCE_DIR})

file(GLOB KBT_VAR_IS_EMPTY LIST_DIRECTORIES false ${KBT_VAR_SOURCE_DIR}/src)
if(NOT KBT_VAR_IS_EMPTY)
    message("Init main source file in src/main.c")
    file(WRITE "${KBT_VAR_SOURCE_DIR}/src/main.c" "//init main file\n\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/src/main.c" "#include \"${KBT_VAR_PROJECT_NAME}.h\" \n\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/src/main.c" "int main() {\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/src/main.c" "  return 0;\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/src/main.c" "}\n")
endif()

file(GLOB KBT_VAR_IS_EMPTY LIST_DIRECTORIES false ${KBT_VAR_SOURCE_DIR}/include)
if(NOT KBT_VAR_IS_EMPTY)
    message("Init main source file in include/${KBT_VAR_PROJECT_NAME}.h")
    string(TOUPPER ${KBT_VAR_PROJECT_NAME} KBT_VAR_NAME_UPPER)
    file(WRITE "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "//init include file\n\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "#ifndef _${KBT_VAR_NAME_UPPER}_H \n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "#define _${KBT_VAR_NAME_UPPER}_H \n\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "#endif \n")
endif()

# create configure file
set(KBT_VAR_CONFIG_FILE ${KBT_VAR_SOURCE_DIR}/${KBT_VAR_PROJECT_NAME}.config)
file(WRITE  ${KBT_VAR_CONFIG_FILE} "#cmakedefine PROJECT_NAME ${KBT_VAR_PROJECT_NAME}\n" )
# file(APPEND ${KBT_VAR_CONFIG_FILE} "#cmakedefine KBT_ARCH ${KBT_ARCH}\n")
# file(APPEND ${KBT_VAR_CONFIG_FILE} "#cmakedefine KBT_PLATFORM ${KBT_PLATFORM}\n")
# file(APPEND ${KBT_VAR_CONFIG_FILE} "#cmakedefine KBT_${PROJECT_NAME}_TYPE ${KBT_${PROJECT_NAME}_TYPE}\n")
#

