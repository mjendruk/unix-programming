
include(${CMAKE_CURRENT_LIST_DIR}/Cppcheck.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ClangTidy.cmake)

set(OPTION_CPPCHECK_ENABLED Off)
set(OPTION_CLANG_TIDY_ENABLED Off)

# Function to register a target for enabled health checks
function(perform_health_checks target)
    if(NOT TARGET check-all)
        add_custom_target(check-all)
    endif()
    
    add_custom_target(check-${target})
    
    if (OPTION_CPPCHECK_ENABLED)
        perform_cppcheck(cppcheck-${target} ${target} ${ARGN})
        add_dependencies(check-${target} cppcheck-${target})
    endif()
    
    if (OPTION_CLANG_TIDY_ENABLED)
        perform_clang_tidy(clang-tidy-${target} ${target} ${ARGN})
        add_dependencies(check-${target} clang-tidy-${target})
    endif()
    
    add_dependencies(check-all check-${target})
endfunction()

# Enable or disable cppcheck for health checks
function(enable_cppcheck status)
    if(NOT ${status})
        set(OPTION_CPPCHECK_ENABLED ${status} PARENT_SCOPE)
        message(STATUS "Check cppcheck skipped: Manually disabled")
        
        return()
    endif()
    
    find_package(cppcheck)
    
    if(NOT cppcheck_FOUND)
        set(OPTION_CPPCHECK_ENABLED Off PARENT_SCOPE)
        message(STATUS "Check cppcheck skipped: cppcheck not found")
        
        return()
    endif()
    
    set(OPTION_CPPCHECK_ENABLED ${status} PARENT_SCOPE)
    message(STATUS "Check cppcheck")
endfunction()

# Enable or disable clang-tidy for health checks
function(enable_clang_tidy status)
    if(NOT ${status})
        set(OPTION_CLANG_TIDY_ENABLED ${status} PARENT_SCOPE)
        message(STATUS "Check clang-tidy skipped: Manually disabled")
        
        return()
    endif()
    
    find_package(clang_tidy)
    
    if(NOT clang_tidy_FOUND)
        set(OPTION_CLANG_TIDY_ENABLED Off PARENT_SCOPE)
        message(STATUS "Check clang-tidy skipped: clang-tidy not found")
        
        return()
    endif()
    
    set(OPTION_CLANG_TIDY_ENABLED ${status} PARENT_SCOPE)
    message(STATUS "Check clang-tidy")
    
    if(${CMAKE_VERSION} VERSION_GREATER "3.5" AND NOT CMAKE_EXPORT_COMPILE_COMMANDS)
        message(STATUS "clang-tidy makes use of the compile commands database. Make sure to configure CMake with -DCMAKE_EXPORT_COMPILE_COMMANDS=ON")
    endif()
endfunction()