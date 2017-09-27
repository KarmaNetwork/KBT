macro(kbt_project name)
    project(${name})
    
    # Create some dirs
    file(MAKE_DIRECTORY src dependenices test include)
    
    # Create test file
    file(WRITE "${PROJECT_NAME}.config" "#cmakedefine PROJECT_NAME ${PROJECT_NAME}\n" )
    file(APPEND "${PROJECT_NAME}.config" "#cmakedefine KBT_ARCH ${KBT_ARCH}\n")
    file(APPEND "${PROJECT_NAME}.config" "#cmakedefine KBT_PLATFORM ${KBT_PLATFORM}\n")
    file(APPEND "${PROJECT_NAME}.config" "#cmakedefine KBT_PROJECT_TYPE ${KBT_PROJECT_TYPE}\n")

    # Download .gitingrone
    kbt_download("https://raw.githubusercontent.com/tiannian/KBT/master/.gitingrone" "${CMAKE_SOURCE_DIR}/.gitingrone")
endmacro(kbt_project name)

macro(kbt_set_arch arch)
    if(NOT KBT_ARCH)
        set(KBT_ARCH ${arch})
    endif(NOT KBT_ARCH)
endmacro(kbt_set_arch arch)

macro(kbt_set_platform platform)
    if(NOT KBT_PLATFORM)
        set(KBT_PLATFORM ${platform})
        kbt_download("https://raw.githubusercontent.com/tiannian/KBT/master/${KBT_PLATFORM}.cmake" "${CMAKE_SOURCE_DIR}/build/${KBT_PLATFORM}.cmake")
        include(${CMAKE_SOURCE_DIR}/build/${KBT_PLATFORM}.cmake)
    endif(NOT KBT_PLATFORM)
endmacro(kbt_set_platform platform)

macro(kbt_set_project_type type)
    if(NOT KBT_PROJECT_TYPE)
        set(KBT_PROJECT_TYPE ${type})
    endif(NOT KBT_PROJECT_TYPE)
endmacro(kbt_set_project_type type)

macro(kbt_add_dependentices dep version)
    file(GLOB kbt_file_status ${CMAKE_SOURCE_DIR}/dependenices/${dep})
    if(NOT kbt_file_status)
        set(kbt_file_status "git clone https://github.com/${dep}.git ${CMAKE_SOURCE_DIR}/dependenices/${dep}")
        exec_program(${kbt_file_status})
        message(${kbt_file_status})
    endif(NOT kbt_file_status)
    #add_subdirectory("${CMAKE_SOURCE_DIR}/dependenices/${dep}")
endmacro(kbt_add_dependentices dep version)

macro(kbt_config)
    configure_file("${PROJECT_NAME}.config" "${PROJECT_SOURCE_DIR}/include/config.h")
    file(GLOB_RECURSE ${PROJECT_NAME}_srcs_list "${PROJECT_SOURCE_DIR}/src/*.c")
    include_directories("${PROJECT_SOURCE_DIR}/include")
    if(KBT_PROJECT_TYPE STREQUAL "lib")
        add_library(${PROJECT_NAME} STATIC ${${PROJECT_NAME}_srcs_list})
    endif(KBT_PROJECT_TYPE STREQUAL "lib")
    if(KBT_PROJECT_TYPE STREQUAL "bin")
        add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_srcs_list})
    endif(KBT_PROJECT_TYPE STREQUAL "bin")
endmacro(kbt_config)
