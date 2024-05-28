# 3.24.1 required to fix warning for gtest download
cmake_minimum_required(VERSION 3.24.1)
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
project(TAOWEP)

# set(CMAKE_C_COMPILER "gcc-4.2")
set(CMAKE_CXX_COMPILER
    "$ENV{HOME}/local/bin/compiler_explorer/gcc-12.1.0/bin/g++")

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}/bin
    CACHE INTERNAL "")

string(
  CONCAT DEFAULT_BUILD_FLAGS
         "-g "
         # do not ignore warnings
         # "-Werror "
         # enable more warnings
         "-Wall "
         "-march=native "
         "-Wextra "
         "-Wshadow "
         "-Wconversion "
         "-Wpedantic ")

# default to release build
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE
      Release
      CACHE INTERNAL "")
endif()

set(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} -L $ENV{HOME}/local/bin/compiler_explorer/gcc-12.1.0/lib64 "
)
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++
# -lc++abi")

if(${CMAKE_BUILD_TYPE} STREQUAL "Release")
  add_definitions(-DNDEBUG)
  set_property(
    DIRECTORY ${CMAKE_SOURCE_DIR}
    APPEND
    PROPERTY COMPILE_DEFINITIONS NDEBUG)
endif()

set(CMAKE_CXX_FLAGS
    ${DEFAULT_BUILD_FLAGS}
    CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS_RELEASE
    "-O3 -flto"
    CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS_DEBUG
    "-O1 -fsanitize=address -fsanitize=leak -fsanitize=undefined -fno-omit-frame-pointer "
    CACHE INTERNAL "")

message("BUILD TYPE: ${CMAKE_BUILD_TYPE}")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(FetchContent)

# ##############################################################################
# get google benchmark
# ##############################################################################
set(BENCHMARK_ENABLE_TESTING OFF)

# https://cliutils.gitlab.io/modern-cmake/chapters/projects/fetch.html
FetchContent_Declare(
  googlebenchmark
  GIT_REPOSITORY https://github.com/google/benchmark.git
  GIT_TAG origin/main)

# FetchContent_MakeAvailable(googletest googlebenchmark)
FetchContent_MakeAvailable(googlebenchmark)

target_compile_options(benchmark PRIVATE -Wno-sign-conversion)

add_subdirectory(Chapter04)
