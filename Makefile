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

libpcsc.a: pcsc/Makefile pcsc/pcsc-nacl.h pcsc/pcsc_nacl_init.cc $(shell find pcsc/src -type f) boost
	$(MAKE) -C pcsc BOOST_DIR='$(shell pwd)/boost'
	cp pcsc/libpcsc.a libpcsc.a.new
	mv libpcsc.a.new libpcsc.a

boost: build-boost
	rm -rf boost
	./build-boost

clean:
	$(MAKE) -C pcsc clean
	rm -f libpcsc.a
	rm -f libpcsc.a.new
	rm -rf workdir-*
	rm -rf boost.new

distclean: clean
	rm -rf boost
	$(MAKE) -C pcsc distclean

mrproper: distclean
	rm -rf pcsc/src

.PHONY: all
