macro(KBT_FUNC_INIT)
    # project(${ARGV0} LANGUAGES NONE)
    set(CMAKE_PROJECT_NAME ${ARGV0})
    set(KBT_VAR_TOOLS_DIR ${CMAKE_BINARY_DIR}/KBT-${KBT_VAR_BRANCH})
    file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/src
        ${CMAKE_SOURCE_DIR}/dependenices
        ${CMAKE_SOURCE_DIR}/test
        ${CMAKE_SOURCE_DIR}/include)
    # copy gitignore file
    file(COPY ${KBT_VAR_TOOLS_DIR}/.gitignore DESTINATION ${CMAKE_SOURCE_DIR})

    file(GLOB KBT_VAR_IS_EMPTY LIST_DIRECTORIES false ${CMAKE_SOURCE_DIR}/src)
    if(NOT KBT_VAR_IS_EMPTY)
        message("Init main source file in src/main.c")
        file(WRITE "${CMAKE_SOURCE_DIR}/src/main.c" "//init main file\n\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/src/main.c" "#include \"${CMAKE_PROJECT_NAME}.h\" \n\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/src/main.c" "int main() {\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/src/main.c" "  return 0;\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/src/main.c" "}\n")
    endif()

    file(GLOB KBT_VAR_IS_EMPTY LIST_DIRECTORIES false ${CMAKE_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}.h)
    if(NOT KBT_VAR_IS_EMPTY)
        message("Init main source file in include/${CMAKE_PROJECT_NAME}.h")
        string(TOUPPER ${CMAKE_PROJECT_NAME} KBT_VAR_NAME_UPPER)
        file(WRITE "${CMAKE_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}.h" "//init include file\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}.h" "#ifndef _${KBT_VAR_NAME_UPPER}_H \n")
        file(APPEND "${CMAKE_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}.h" "#define _${KBT_VAR_NAME_UPPER}_H \n\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}.h" "#include \"${CMAKE_PROJECT_NAME}.config.h\" \n\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/include/${CMAKE_PROJECT_NAME}.h" "#endif \n")
    endif()
endmacro()

