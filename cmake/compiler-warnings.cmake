include(CheckCompilerFlagAndEnableIt)
include(CheckCCompilerFlagAndEnableIt)
include(CheckCXXCompilerFlagAndEnableIt)

CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wall)

CHECK_COMPILER_FLAG_AND_ENABLE_IT(-fno-strict-aliasing)

CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wformat)
CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wformat-security)

# cleanup this once we no longer need to support gcc-4.9
if(NOT (CMAKE_C_COMPILER_ID STREQUAL "GNU" AND CMAKE_C_COMPILER_VERSION VERSION_LESS 5.0))
  CHECK_C_COMPILER_FLAG_AND_ENABLE_IT(-Wshadow)
endif()
if(NOT (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 5.0))
  CHECK_CXX_COMPILER_FLAG_AND_ENABLE_IT(-Wshadow)
endif()

CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wtype-limits)

CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wvla)

CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wold-style-declaration)

# may be our bug :(
CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wno-error=varargs)

# clang-4.0 bug https://llvm.org/bugs/show_bug.cgi?id=28115#c7
CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wno-error=address-of-packed-member)

# should be < 64Kb
math(EXPR MAX_MEANINGFUL_SIZE 32*1024)
CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wframe-larger-than=${MAX_MEANINGFUL_SIZE})
CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wstack-usage=${MAX_MEANINGFUL_SIZE})

# 1Mb
# # src/iop/ashift_lsd.c, nfa(), static double inv[TABSIZE]; <- 800000 bytes
# # src/external/wb_presets.c, wb_preset <- ~400Kb
math(EXPR MAX_MEANINGFUL_SIZE 1*1024*1024)
CHECK_COMPILER_FLAG_AND_ENABLE_IT(-Wlarger-than=${MAX_MEANINGFUL_SIZE})

# minimal stack/frame stack size. (musl)
# let's see if 1Mb is good-enough...
# MUST be a multiple of the system page size !!!
math(EXPR WANTED_STACK_SIZE 1*1024*1024)

if(SOURCE_PACKAGE)
  add_definitions(-D_RELEASE)
endif()

###### GTK+3 ######
#
#  Do not include individual headers
#
add_definitions(-DGTK_DISABLE_SINGLE_INCLUDES)

#
# Dirty hack to enforce GTK3 behaviour in GTK2: "Replace GDK_<keyname> with GDK_KEY_<keyname>"
#
add_definitions(-D__GDK_KEYSYMS_COMPAT_H__)

#
#  Do not use deprecated symbols
#
add_definitions(-DGDK_DISABLE_DEPRECATED)
add_definitions(-DGTK_DISABLE_DEPRECATED)
###### GTK+3 port ######
