macro(KBT_PROJECT)
    project(${ARGV0})
    set(KBT_PROJECT_NAME ${ARGV0})
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
    endif()
endmacro()

macro(KBT_ADD_DEPENDENTICES)
    file(GLOB KBT_VAR_DEPENDIENCE_EXISTS "${CMAKE_SOURCE_DIR}/dependenices/${dep}")
    # check remote repo version and exist
    KBT_FUNC_CHECK_REMOTE_REPO_VERSION(${ARGV0} ${ARGV1})
    if(NOT KBT_VAR_DEPENDIENCE_EXISTS)
        execute_process(COMMAND git clone --recursive https://github.com/${dep}.git ${CMAKE_SOURCE_DIR}/dependenices/${dep})
        file(COPY ${CMAKE_SOURCE_DIR}/dependenices/${dep}/include DESTINATION ${CMAKE_BINARY_DIR}/include/${dep})
    endif()
    add_subdirectory("${CMAKE_SOURCE_DIR}/dependenices/${dep}")
    # include_directories("${CMAKE_BINARY_DIR}/include")
    if(KBT_${PROJECT_NAME}_TYPE STREQUAL "lib")
        list(APPEND LIB_DEPENDENTICES ${PROJECT_NAME})
    endif(KBT_${PROJECT_NAME}_TYPE STREQUAL "lib")
endmacro()

macro(KBT_CONFIG)
    file(GLOB KBT_VAR_CONFIG_EXISTS ${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config)
    if(NOT KBT_VAR_CONFIG_EXISTS)
        # Create test file
        # set(KBT_VAR_CONFIG_FILE ${KBT_VAR_SOURCE_DIR}/${KBT_VAR_PROJECT_NAME}.config)
        file(WRITE  "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" "#cmakedefine KBT_PROJECT_NAME ${PROJECT_NAME}\n" )
        file(APPEND "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" "#cmakedefine KBT_ARCH ${KBT_ARCH}\n")
        file(APPEND "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" "#cmakedefine KBT_PLATFORM ${KBT_PLATFORM}\n")
        file(APPEND "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" "#cmakedefine KBT_${KBT_VAR_PROJECT}_TYPE ${KBT_${KBT_VAR_PROJECT}_TYPE}\n")
        configure_file("${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.config" ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}.config.h)        
    endif()
    # Scan all source file
    file(GLOB_RECURSE KBT_VAR_SOURCES_FILES_LIST "${PROJECT_SOURCE_DIR}/src/*.c")
    if(KBT_VAR_SOURCES_FILES_LIST)
        include_directories(${CMAKE_SOURCE_DIR}/include)
        if(KBT_${KBT_VAR_PROJECT}_TYPE STREQUAL "lib")
            add_library(${PROJECT_NAME} STATIC ${KBT_VAR_SOURCES_FILES_LIST})
        endif()
        # Build bin project
        if(KBT_${KBT_VAR_PROJECT}_TYPE STREQUAL "bin")
            add_executable(${PROJECT_NAME} ${KBT_VAR_SOURCE_DIR)
            # target_link_libraries(${PROJECT_NAME} ${LIB_DEPENDENTICES})
        endif()
    endif()
    # Add init command in makefile
    add_custom_target(init cmake -D KBT_VAR_SOURCE_DIR=${CMAKE_SOURCE_DIR}
                  -D KBT_VAR_TOOLS_DIR=${CMAKE_BINARY_DIR}/KBT-${KBT_VAR_BRANCH}
                  -D KBT_VAR_PROJECT_NAME=${PROJECT_NAME}
                  -D KBT_VAR_PROJECT_TYPE=${KBT_${KBT_VAR_PROJECT}_TYPE}
                  -P ${KBT_VAR_TOOLS_DIR}/lib/init.cmake
                  COMMAND make rebuild_cache)
endmacro()
