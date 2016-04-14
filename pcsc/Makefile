BOOST_DIR := /usr
CFLAGS    += -Wall -std=gnu11 -g3 -ggdb3
CXXFLAGS  += -Wall -std=gnu++11 -g3 -ggdb3
CPPFLAGS  += -Isrc/include/PCSC -isystem $(BOOST_DIR)/include -Isrc -isystem $(NACL_SDK_ROOT)/include

OBJS += pcsc_nacl_init.o

all: libpcsc.a

include Makefile.deps

libpcsc.a: $(OBJS)
	rm -f libpcsc.a
	$(AR) rc libpcsc.a $(OBJS)
	-$(RANLIB) libpcsc.a

%.o: src/%.cc
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o "$@" $(filter %.cc,$^)

%.o: src/%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o "$@" $(filter %.c,$^)

Makefile.deps:
	rm -f Makefile.deps.new
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -MM src/*.cc > Makefile.deps.new
	$(CC) $(CFLAGS) $(CPPFLAGS) -MM src/*.c >> Makefile.deps.new
	grep ': ' Makefile.deps.new | cut -f 1 -d : | sed 's@^@OBJS += @' >> Makefile.deps.new
	mv Makefile.deps.new Makefile.deps

clean:
	rm -f $(OBJS)
	rm -f libpcsc.a
	rm -f Makefile.deps.new

distclean: clean
	rm -f Makefile.deps

.PHONY: all clean distclean
