set(os_arch "x86_64")
set(CMAKE_OSX_ARCHITECTURES "${os_arch}" CACHE STRING "Cache architectures so it's used by try_compile")
set(CMAKE_C_COMPILER /usr/bin/clang)
set(CMAKE_CXX_COMPILER /usr/bin/clang++)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -arch ${os_arch} -std=gnu++11 -stdlib=libc++" CACHE STRING "Compiler flags")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -arch ${os_arch}" CACHE STRING "Compiler flags")
set(CMAKE_SYSTEM_PROCESSOR "x86_65")