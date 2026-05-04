cmake_minimum_required(VERSION 3.10)
project(calibracion)

set(CMAKE_CXX_STANDARD 14)

find_package(OpenCV REQUIRED)

include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(calibracion main.cpp)

target_link_libraries(calibracion ${OpenCV_LIBS})
