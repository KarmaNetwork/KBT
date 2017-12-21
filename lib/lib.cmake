macro(KBT_FUNC_DOWNLOAD KBT_VAR_REMOTE KBT_VAR_LOCAL)
    file(GLOB KBT_VAR_FILE_EXIST ${KBT_VAR_LOCAL})
    if(NOT KBT_VAR_FILE_EXIST)
        message("Fetch ${KBT_VAR_REMOTE}...")
        file(DOWNLOAD ${KBT_VAR_REMOTE} ${KBT_VAR_LOCAL} STATUS KBT_VAR_DOWNLOAD_RESULT)
        list(GET KBT_VAR_DOWNLOAD_RESULT 0 KBT_VAR_DOWNLOAD_CODE)
        if(NOT (KBT_VAR_DOWNLOAD_CODE EQUAL 0))
            message("DOWNLOAD ${KBT_VAR_REMOTE} failed, please check your network connection")
            return()
        endif()
    endif()
endmacro()