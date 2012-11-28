.PHONY: all clean test

include ./Makefile.in

all:
	swig -perl5 parisrv.i
	gcc $(CFLAGS) parisrv.c parisrv_wrap.c 
	gcc $(LDFLAGS) parisrv.o parisrv_wrap.o -o parisrv.so

clean :
	rm -f *.o
	rm -f parisrv.pm
	rm -f parisrv.so
	rm -f parisrv_wrap.c








