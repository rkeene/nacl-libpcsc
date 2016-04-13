CFLAGS   += -Wall -std=gnu++11 -g3 -ggdb3
CXXFLAGS += -Wall -std=gnu++11 -g3 -ggdb3
CPPFLAGS += -I../src/src/PCSC

OBJS = pcsc_nacl.o pcsc_nacl_global.o scard_structs_serialization.o pp_var_utils.o logging.o dom_requests_manager.o pcsc_nacl_init.o

all: libpcsc.a

libpcsc.a: $(OBJS)
	rm -f libpcsc.a
	$(AR) rc libpcsc.a $(OBJS)
	-$(RANLIB) libpcsc.a

pcsc_nacl_init.o: pcsc_nacl_init.cc pcsc_nacl_global.h dom_requests_manager.h pcsc_nacl.h

pcsc_nacl.o: pcsc_nacl.cc pcsc_nacl.h logging.h pp_var_utils.h scard_structs_serialization.h
pcsc_nacl.h: dom_requests_manager.h thread_safe_string_pool.h

pcsc_nacl_global.o: pcsc_nacl_global.cc pcsc_nacl_global.h logging.h
pcsc_nacl_global.h: pcsc_nacl.h

pp_var_utils.o: pp_var_utils.cc pp_var_utils.h logging.h
pp_var_utils.h: logging.h

scard_structs_serialization.o: scard_structs_serialization.cc scard_structs_serialization.h pp_var_utils.h
scard_structs_serialization.h: pp_var_utils.h

dom_requests_manager.o: dom_requests_manager.cc dom_requests_manager.h logging.h pp_var_utils.h

logging.o: logging.cc logging.h

clean:
	rm -f $(OBJS)
	rm -f libpcsc.a

distclean: clean

.PHONY: all clean distclean
