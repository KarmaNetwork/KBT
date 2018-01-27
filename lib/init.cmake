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

file(GLOB KBT_VAR_IS_EMPTY LIST_DIRECTORIES false ${KBT_VAR_SOURCE_DIR}/src/main.c)
if(NOT KBT_VAR_IS_EMPTY)
    message("Init main source file in src/main.c")
    file(WRITE "${KBT_VAR_SOURCE_DIR}/src/main.c" "//init main file\n\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/src/main.c" "#include \"${KBT_VAR_PROJECT_NAME}.h\" \n\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/src/main.c" "int main() {\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/src/main.c" "  return 0;\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/src/main.c" "}\n")
endif()

file(GLOB KBT_VAR_IS_EMPTY LIST_DIRECTORIES false ${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h)
if(NOT KBT_VAR_IS_EMPTY)
    message("Init main source file in include/${KBT_VAR_PROJECT_NAME}.h")
    string(TOUPPER ${KBT_VAR_PROJECT_NAME} KBT_VAR_NAME_UPPER)
    file(WRITE "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "//init include file\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "#ifndef _${KBT_VAR_NAME_UPPER}_H \n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "#define _${KBT_VAR_NAME_UPPER}_H \n\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "#include \"${KBT_VAR_PROJECT_NAME}.config.h\" \n\n")
    file(APPEND "${KBT_VAR_SOURCE_DIR}/include/${KBT_VAR_PROJECT_NAME}.h" "#endif \n")
endif()
# configure_file("${KBT_VAR_SOURCE_DIR}/${KBT_VAR_PROJECT_NAME}.config" "${KBT_VAR_SOURCE_DIR}/include/config.h")


