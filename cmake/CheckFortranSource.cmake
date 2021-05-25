macro (CHECK_FORTRAN_SOURCE_RUN file var docstr)

  if (DEFINED CACHE{PFUNIT${var}})
  
    set( ${var} ${PFUNIT${var}})

  else ()

    if ( NOT ("${CMAKE_REQUIRED_FLAGS}" STREQUAL ""))
      string(REPLACE "=" "" compile_flags ${CMAKE_REQUIRED_FLAGS})
    endif ()
  
    get_filename_component(binname ${file} NAME_WLE)
  
    execute_process(
      COMMAND ${CMAKE_Fortran_COMPILER} ${CMAKE_REQUIRED_DEFINITIONS} ${compile_flags} ${file} "-o" "${binname}.exe"
      RESULT_VARIABLE error
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      OUTPUT_QUIET
      ERROR_QUIET
      )
    
    if ( NOT error)
      execute_process(
        COMMAND "${binname}.exe"
        RESULT_VARIABLE error
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        OUTPUT_VARIABLE out
        )
    endif ()

    if (NOT error)
      string(STRIP ${out} ${var})
      if (NOT CMAKE_REQUIRED_QUIET)
        message(STATUS "Performing Test ${var}: SUCCESS (value=${${var}})")
      endif ()
    
      set ( PFUNIT${var} ${${var}} CACHE STRING ${docstr} )
      
    else ()

      if (NOT CMAKE_REQUIRED_QUIET)
        message(STATUS "Performing Test ${var}: FAILURE")
      endif ()
      
    endif ()
    
  endif ()
   
  if (NOT ${${var}} EQUAL "")
    add_definitions(-D${var}=${${var}})
  endif ()

endmacro (CHECK_FORTRAN_SOURCE_RUN)


macro (CHECK_FORTRAN_SOURCE_COMPILE file var)

  try_compile (
    code_compiles
    ${CMAKE_BINARY_DIR}
    ${file}
    CMAKE_FLAGS "-DCOMPILE_DEFINITIONS=${CMAKE_REQUIRED_DEFINITIONS}"
    )

  if (${code_compiles})

    set(${var} SUCCESS)
    if (NOT CMAKE_REQUIRED_QUIET)
      message (STATUS "Performing Test ${var}: SUCCESS")
    endif ()

    add_definitions(-D${var})

  else ()

      if (NOT CMAKE_REQUIRED_QUIET)
	message (STATUS "Performing Test ${var}: BUILD FAILURE")
      endif ()

  endif()

endmacro (CHECK_FORTRAN_SOURCE_COMPILE)
