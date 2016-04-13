# Setup cross-compiler toolchain
## Set path to include the tools
PATH := ${PATH}:${NACL_SDK_ROOT}/toolchain/linux_pnacl/bin
export PATH

## Set variables needed by projects
HOST_CC      := $(shell which "$${CC:-cc}")
BUILD_CC     := ${HOST_CC}
CC_FOR_BUILD := ${HOST_CC}
AR           := pnacl-ar
AS           := pnacl-as
LD           := pnacl-ld
CC           := pnacl-clang
CXX          := pnacl-clang++
RANLIB       := pnacl-ranlib
STRIP        := pnacl-strip
OBJCOPY      := pnacl-objcopy
export HOST_CC BUILD_CC CC_FOR_BUILD AR AS LD CC CXX RANLIB STRIP OBJCOPY

## Set some CFLAGS that the compiler fails to internally set
CFLAGS       := -I${NACL_SDK_ROOT}/include
CXXFLAGS     := $(CFLAGS)
CPPFLAGS     := $(CFLAGS)
export CFLAGS CXXFLAGS CPPFLAGS

all: libpcsc.a

libpcsc.a:

boost: build-boost
	rm -rf boost
	./build-boost

.PHONY: all
