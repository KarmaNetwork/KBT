macro(KBT_FUNC_CHECK_REMOTE_REPO_VERSION)
    file(DOWNLOAD https://raw.githubusercontent.com/${ARGV0}/master/version ${CMAKE_BINARY_DIR}/versions/${ARGV0}.version)
    file(READ ${CMAKE_BINARY_DIR}/versions/${ARGV0}.version KBT_VAR_REMOTE_REPO_VERSION)
    if(KBT_VAR_REMOTE_REPO_VERSION VERSION_LESS ARGV1)
        message(FATAL_ERROR "repo ${ARGV0} must greater than ${ARGV1}")
    endif()
endmacro()

