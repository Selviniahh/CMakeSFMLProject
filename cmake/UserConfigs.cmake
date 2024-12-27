# cmake/UserConfigs.cmake

# Library dependency has 3 options  FETCHCONTENT, VCPKG, or SOURCEBUILD. Only these 3 option can be given. 
set(BuildType "SourceBuild" CACHE STRING "Specify how to build the project: FetchContent, Vcpkg, or SourceBuild, by default SourceBuild is given")
set(BuildTypeEnum "FetchContent" "Vcpkg" "SourceBuild")

# Convert elements to upper to be not case sensitive 
string(TOUPPER ${BuildType} BuildType)
list(TRANSFORM BuildTypeEnum TOUPPER OUTPUT_VARIABLE UpperBuildTypeEnum)

# Set the toolchain vcpkg file if build option is given for vcpkg. VCPKG_CMAKE environment variable has to be given to the vcpkg.cmake path. Otherwise fatal error will be given
if (BuildType STREQUAL "VCPKG")
    if (NOT DEFINED ENV{VCPKG_CMAKE})
        message(FATAL_ERROR "VCPKG_CMAKE environment variable is not set. VCPKG_CMAKE should be equal to ..vcpkg/scripts/buildsystems/vcpkg.cmake")
    endif ()
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_CMAKE}")
endif ()

# Use custom compiled libc++ to be able to step into libc++ implementation if desired
SET(CUSTOM_STD OFF CACHE BOOL "If custom STD is desired, enable this")
if (${CUSTOM_STD} STREQUAL "ON")
    SET(CUSTOM_STD_RELEASE ON CACHE BOOL "IF CUSTOM_STD Desired. Configure this option to use release or debug mode.")
    if (${CUSTOM_STD_RELEASE} STREQUAL "ON")
        set(STD_INCLUDE_DIR "/home/selviniah/Documents/llvm-project/build/include/c++/v1")
        set(STD_LIB_DIR "/home/selviniah/Documents/llvm-project/build/lib")
    else ()
        set(STD_INCLUDE_DIR "/home/selviniah/Documents/llvm-project/_InstallLibcxxDebug/include/c++/v1")
        set(STD_LIB_DIR "/home/selviniah/Documents/llvm-project/_InstallLibcxxDebug/lib")
    endif ()


    add_compile_options(-Wshadow -Wall -Wextra -Wpedantic -Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-newline-eof
            -nostdinc++ -Wno-reserved-macro-identifier) # -fno-elide-constructors

    link_directories(${STD_LIB_DIR})
    include_directories(${STD_INCLUDE_DIR})
endif ()
