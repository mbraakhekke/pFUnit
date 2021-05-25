include (${PROJECT_SOURCE_DIR}/cmake/CheckFortranSource.cmake)

CHECK_FORTRAN_SOURCE_RUN (
  ${PROJECT_SOURCE_DIR}/cmake/Trial_sources/LOGICAL_DEFAULT_KIND.F90
  _LOGICAL_DEFAULT_KIND
  "Default logical kind"
  )

CHECK_FORTRAN_SOURCE_RUN (
  ${PROJECT_SOURCE_DIR}/cmake/Trial_sources/INT_DEFAULT_KIND.F90
  _INT_DEFAULT_KIND
  "Default integer kind"
  )
foreach (kind 8 16 32 64)

  set(CMAKE_REQUIRED_FLAGS = -fpp)
  set(CMAKE_REQUIRED_DEFINITIONS -D_KIND=INT${kind})

  CHECK_FORTRAN_SOURCE_RUN (
    ${PROJECT_SOURCE_DIR}/cmake/Trial_sources/INT_KIND.F90
    _ISO_INT${kind}
    "Integer(${kind}) kind"
    )

endforeach()

CHECK_FORTRAN_SOURCE_RUN (
  ${PROJECT_SOURCE_DIR}/cmake/Trial_sources/REAL_DEFAULT_KIND.F90
  _REAL_DEFAULT_KIND
  "Default real kind"
  )

CHECK_FORTRAN_SOURCE_RUN (
  ${PROJECT_SOURCE_DIR}/cmake/Trial_sources/DOUBLE_DEFAULT_KIND.F90
  _DOUBLE_DEFAULT_KIND
  "Default double kind"
  )

foreach (kind 32 64 80 128 256)

  if (DEFINED CACHE{PFUNIT_ISO_REAL${kind}})
  
	set(_ISO_REAL${kind} ${PFUNIT_ISO_REAL${kind}})
    add_definitions(-D_ISO_REAL${kind}=${_ISO_REAL${kind}})
    
  else ()
  
    set(CMAKE_REQUIRED_FLAGS = -fpp)
    set(CMAKE_REQUIRED_DEFINITIONS -D_KIND=REAL${kind})
  
    if ( NOT ("${CMAKE_REQUIRED_FLAGS}" STREQUAL ""))
      string(REPLACE "=" "" compile_flags ${CMAKE_REQUIRED_FLAGS})
    endif ()
    
    execute_process(
      COMMAND ${CMAKE_Fortran_COMPILER} ${CMAKE_REQUIRED_DEFINITIONS} ${compile_flags} ${CMAKE_CURRENT_LIST_DIR}/trial_sources/REAL_KIND.F90 "-o" "REAL_KIND_${kind}.exe"
      RESULT_VARIABLE error
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      OUTPUT_QUIET
      ERROR_QUIET
      )
    
    if (NOT error)
      CHECK_FORTRAN_SOURCE_RUN (
        ${PROJECT_SOURCE_DIR}/cmake/Trial_sources/REAL_KIND.F90
        _ISO_REAL${kind}
        "Real(${kind}) kind"
        )
    endif ()
    
  endif ()
  
  if (DEFINED CACHE{PFUNIT_REAL${kind}_IEEE_SUPPORT})
  
    add_definitions(-D_REAL${kind}_IEEE_SUPPORT=${PFUNIT_REAL${kind}_IEEE_SUPPORT})
    
  else ()
    
    execute_process(
      COMMAND ${CMAKE_Fortran_COMPILER} ${CMAKE_REQUIRED_DEFINITIONS} ${compile_flags} ${CMAKE_CURRENT_LIST_DIR}/trial_sources/REAL_KIND.F90 "-o" "REAL_KIND_${kind}.exe"
      RESULT_VARIABLE error
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      OUTPUT_QUIET
      ERROR_QUIET
      )

    if (NOT error)
      CHECK_FORTRAN_SOURCE_RUN(
        ${PROJECT_SOURCE_DIR}/cmake/Trial_sources/REAL_KIND_IEEE_SUPPORT.F90
        _REAL${kind}_IEEE_SUPPORT
         "Support for IEEE real(${kind}) kind"
        )
        
    endif ()

  endif ()

endforeach()



