cmake_minimum_required(VERSION 3.8)
project(yoga)
include(ExternalProject)
set (CMAKE_CXX_STANDARD 11)
if(CMAKE_BUILD_TYPE MATCHES Debug)
  set(debug_flag "_debug")
endif()

# ----------------------------------------------------------
ExternalProject_Add(
  yoga
  GIT_REPOSITORY https://github.com/facebook/yoga.git
  GIT_SHALLOW 1
  INSTALL_COMMAND ""
  UPDATE_COMMAND ""
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  )

ExternalProject_Get_Property(yoga binary_dir)
ExternalProject_Get_Property(yoga source_dir)
list(APPEND poly_libs ${binary_dir}/libyogacore.a)
include_directories(${source_dir}/yoga)
list(APPEND poly_deps yoga)
# ----------------------------------------------------------

set(bd ${CMAKE_CURRENT_LIST_DIR}/../)
set(sd ${bd}/src)

include_directories(
  ${sd}
  ${POLY_DIR}/include
  ${D3_DIR}/include
  )

macro(create_test name)
  set(test_name "test_${name}${debug_flag}")
  add_executable(${test_name} ${sd}/test/test_${name}.cpp)
  target_link_libraries(${test_name} ${poly_libs})
  install(TARGETS ${test_name} DESTINATION bin/)
  add_dependencies(${test_name} ${poly_deps})
endmacro()

create_test("yoga")


