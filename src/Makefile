.PHONY: all clean test

include ../Makefile.in

all:
	swig -perl5 parisv.i
	gcc $(CFLAGS) parisv.c parisv_wrap.c 
	gcc $(LDFLAGS) parisv.o parisv_wrap.o -o parisv.so

clean :
	rm -f *.o
	rm -f parisv.pm
	rm -f parisv.so
	rm -f parisv_wrap.c








