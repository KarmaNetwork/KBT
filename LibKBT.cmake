macro(KBT_PROJECT)
    project(${ARGV0})
    set(KBT_PROJECT_NAME ${ARGV0})
    set(KBT_VAR_TOOLS_DIR ${CMAKE_BINARY_DIR}/KBT-${KBT_VAR_BRANCH})
    file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/src
        ${CMAKE_SOURCE_DIR}/dependenices
        ${CMAKE_SOURCE_DIR}/test
        ${CMAKE_SOURCE_DIR}/include)

    # copy gitignore file
    file(COPY ${KBT_VAR_TOOLS_DIR}/.gitignore DESTINATION ${CMAKE_SOURCE_DIR})

    file(GLOB KBT_VAR_IS_EMPTY LIST_DIRECTORIES false ${CMAKE_SOURCE_DIR}/src/main.c)
    if(NOT KBT_VAR_IS_EMPTY)
        message("Init main source file in src/main.c")
        file(WRITE "${CMAKE_SOURCE_DIR}/src/main.c" "//init main file\n\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/src/main.c" "#include \"${KBT_PROJECT_NAME}.h\" \n\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/src/main.c" "int main() {\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/src/main.c" "  return 0;\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/src/main.c" "}\n")
    endif()

    file(GLOB KBT_VAR_IS_EMPTY LIST_DIRECTORIES false ${CMAKE_SOURCE_DIR}/include/${KBT_PROJECT_NAME}.h)
    if(NOT KBT_VAR_IS_EMPTY)
        message("Init main source file in include/${KBT_PROJECT_NAME}.h")
        string(TOUPPER ${KBT_PROJECT_NAME} KBT_VAR_NAME_UPPER)
        file(WRITE "${CMAKE_SOURCE_DIR}/include/${KBT_PROJECT_NAME}.h" "//init include file\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/include/${KBT_PROJECT_NAME}.h" "#ifndef _${KBT_VAR_NAME_UPPER}_H \n")
        file(APPEND "${CMAKE_SOURCE_DIR}/include/${KBT_PROJECT_NAME}.h" "#define _${KBT_VAR_NAME_UPPER}_H \n\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/include/${KBT_PROJECT_NAME}.h" "#include \"${KBT_PROJECT_NAME}.config.h\" \n\n")
        file(APPEND "${CMAKE_SOURCE_DIR}/include/${KBT_PROJECT_NAME}.h" "#endif \n")
    endif()
endmacro()

macro(KBT_SET_ARCH)
    if(NOT KBT_ARCH)
        set(KBT_ARCH ${ARGV0})
    endif()
endmacro()

macro(KBT_SET_PLATFORM)
    file(GLOB KBT_VAR_FILE_EXISTS ${KBT_VAR_TOOLS_DIR}/platform/${ARGV0}.cmake)
    if(NOT KBT_VAR_FILE_EXISTS)
        message(FATAL_ERROR "Specified platform does not exist. Please check detail in project github pages.")
    endif()
    if(NOT KBT_PLATFORM)
        set(KBT_PLATFORM ${ARGV0})
        include(${KBT_VAR_TOOLS_DIR}/platform/${KBT_PLATFORM}.cmake)
    endif()
endmacro()

macro(KBT_SET_PROJECT_TYPE)
    if(NOT KBT_${PROJECT_NAME}_TYPE)
        string(TOUPPER ${PROJECT_NAME} KBT_VAR_PROJECT)
        set(KBT_${KBT_VAR_PROJECT}_TYPE ${ARGV0})
        if(KBT_${KBT_VAR_PROJECT}_TYPE STREQUAL "lib")
            list(APPEND LIB_DEPENDENTICES ${PROJECT_NAME})
        endif()
    endif()
endmacro()

macro(KBT_ADD_DEPENDENTICES)
    file(GLOB KBT_VAR_DEPENDIENCE_EXISTS "${CMAKE_SOURCE_DIR}/dependenices/${ARGV0}-${ARGV1}")
    # check remote repo version and exist
    if(NOT KBT_VAR_DEPENDIENCE_EXISTS)
        string(REGEX REPLACE [/] ";" KBT_VAR_DEP ${ARGV0})
        list(GET KBT_VAR_DEP 0 KBT_VAR_PARENT)
        list(GET KBT_VAR_DEP 1 KBT_VAR_DEP_NAME)
        file(MAKE_DIRECTORY ${CMAKE_SOURCE_DIR}/dependenices/${KBT_VAR_PARENT})
        execute_process(COMMAND curl https://codeload.github.com/${ARGV0}/tar.gz/${ARGV1} 
            COMMAND tar -zxv WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/dependenices/${KBT_VAR_PARENT})
        file(COPY ${CMAKE_SOURCE_DIR}/dependenices/${ARGV0}-${ARGV1}/include DESTINATION ${CMAKE_BINARY_DIR}/include/${KBT_VAR_PARENT})
        file(RENAME ${CMAKE_BINARY_DIR}/include/${KBT_VAR_PARENT}/include ${CMAKE_BINARY_DIR}/include/${ARGV0})
    endif()
    # add_subdirectory("${CMAKE_SOURCE_DIR}/dependenices/${ARGV0}-${ARGV1}" ${CMAKE_BINARY_DIR}/dependenices/${ARGV0}-${ARGV1})
    add_subdirectory("${CMAKE_SOURCE_DIR}/dependenices/${ARGV0}-${ARGV1}")
    # include_directories("${CMAKE_BINARY_DIR}/include")
endmacro()

macro(KBT_CONFIG)
    file(GLOB KBT_VAR_CONFIG_EXISTS ${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config)
    if(NOT KBT_VAR_CONFIG_EXISTS)
        # Create test file
        file(WRITE  "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" "#cmakedefine KBT_PROJECT_NAME ${PROJECT_NAME}\n" )
        file(APPEND "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" "#cmakedefine KBT_ARCH ${KBT_ARCH}\n")
        file(APPEND "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" "#cmakedefine KBT_PLATFORM ${KBT_PLATFORM}\n")
        file(APPEND "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" "#cmakedefine KBT_${KBT_VAR_PROJECT}_TYPE ${KBT_${KBT_VAR_PROJECT}_TYPE}\n")
    endif()
    configure_file("${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}.config.h)
    # Scan all source file
    file(GLOB_RECURSE KBT_VAR_SOURCES_FILES_LIST "${PROJECT_SOURCE_DIR}/src/*.c")
    if(KBT_VAR_SOURCES_FILES_LIST)
        # include_directories(${CMAKE_SOURCE_DIR}/include)
        message(LIB_DEPENDENTICES)
        include_directories(${PROJECT_SOURCE_DIR}/include)
        include_directories(${CMAKE_BINARY_DIR}/include)
        if(KBT_${KBT_VAR_PROJECT}_TYPE STREQUAL "lib")
            add_library(${PROJECT_NAME} STATIC ${KBT_VAR_SOURCES_FILES_LIST})
        endif()
        # Build bin project
        if(KBT_${KBT_VAR_PROJECT}_TYPE STREQUAL "bin")
            add_executable(${PROJECT_NAME} ${KBT_VAR_SOURCES_FILES_LIST})
            if (LIB_DEPENDENTICES)
                list(REMOVE_DUPLICATES LIB_DEPENDENTICES)
                target_link_libraries(${PROJECT_NAME} ${LIB_DEPENDENTICES})
            endif()
        endif()
    endif()
    # Add init command in makefile
    # add_custom_target(init cmake -D CMAKE_SOURCE_DIR=${CMAKE_SOURCE_DIR}
    #               -D KBT_VAR_TOOLS_DIR=${CMAKE_BINARY_DIR}/KBT-${KBT_VAR_BRANCH}
    #               -D KBT_PROJECT_NAME=${PROJECT_NAME}
    #               -D KBT_VAR_PROJECT_TYPE=${KBT_${KBT_VAR_PROJECT}_TYPE}
    #               -P ${KBT_VAR_TOOLS_DIR}/lib/init.cmake
    #               COMMAND make rebuild_cache)
endmacro()
