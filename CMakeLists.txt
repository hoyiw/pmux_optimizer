cmake_minimum_required(VERSION 3.20)
project(pmux_opt_plugin LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(YOSYS_BUILD_DIR "" CACHE PATH "Yosys build directory")
set(YOSYS_INCLUDE_DIR "" CACHE PATH "Directory containing kernel/yosys.h")
set(YOSYS_LIBRARY "" CACHE FILEPATH "Optional libyosys import library")

if (NOT YOSYS_INCLUDE_DIR)
    if (YOSYS_BUILD_DIR)
        set(YOSYS_INCLUDE_DIR "${YOSYS_BUILD_DIR}/share/include")
    else()
        find_program(YOSYS_CONFIG_EXECUTABLE NAMES yosys-config)
        if (NOT YOSYS_CONFIG_EXECUTABLE)
            message(FATAL_ERROR
                "Set -DYOSYS_BUILD_DIR=<yosys build dir> or put yosys-config on PATH.")
        endif()
        execute_process(
            COMMAND "${YOSYS_CONFIG_EXECUTABLE}" --datdir
            OUTPUT_VARIABLE YOSYS_DATDIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
            RESULT_VARIABLE YOSYS_CONFIG_RESULT)
        if (NOT YOSYS_CONFIG_RESULT EQUAL 0)
            message(FATAL_ERROR "yosys-config --datdir failed")
        endif()
        set(YOSYS_INCLUDE_DIR "${YOSYS_DATDIR}/include")
    endif()
endif()

if (NOT EXISTS "${YOSYS_INCLUDE_DIR}/kernel/yosys.h")
    message(FATAL_ERROR
        "kernel/yosys.h was not found under ${YOSYS_INCLUDE_DIR}")
endif()

add_library(pmux_opt MODULE src/pmux_opt.cc)
target_include_directories(pmux_opt PRIVATE "${YOSYS_INCLUDE_DIR}")
target_compile_definitions(pmux_opt PRIVATE _YOSYS_)

if (MSVC)
    target_compile_options(pmux_opt PRIVATE /W4 /permissive-)
    if (NOT YOSYS_LIBRARY AND YOSYS_BUILD_DIR)
        foreach(candidate
                "${YOSYS_BUILD_DIR}/libyosys.lib"
                "${YOSYS_BUILD_DIR}/RelWithDebInfo/libyosys.lib"
                "${YOSYS_BUILD_DIR}/Release/libyosys.lib")
            if (EXISTS "${candidate}")
                set(YOSYS_LIBRARY "${candidate}")
                break()
            endif()
        endforeach()
    endif()
else()
    target_compile_options(pmux_opt PRIVATE -Wall -Wextra)
    if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        target_link_options(pmux_opt PRIVATE -undefined dynamic_lookup)
    endif()
endif()

if (YOSYS_LIBRARY)
    target_link_libraries(pmux_opt PRIVATE "${YOSYS_LIBRARY}")
endif()

set_target_properties(pmux_opt PROPERTIES
    PREFIX ""
    OUTPUT_NAME "pmux_opt"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
