add_compiler_rt_component(hp)
include_directories(..)

set(HP_SOURCES
${CMAKE_CURRENT_SOURCE_DIR}/lib.c
)


append_list_if(COMPILER_RT_HAS_STD_C11_FLAG -std=c11 CRT_CFLAGS)

foreach(arch ${HP_SUPPORTED_ARCH})
add_compiler_rt_runtime(clang_rt.hp
    OBJECT
    ARCHS ${arch}
    SOURCES ${HP_SOURCES}
    CFLAGS ${HP_CFLAGS}
    PARENT_TARGET hp)
endforeach()