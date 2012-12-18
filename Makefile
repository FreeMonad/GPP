.PHONY: all parisrv clean

all: parisrv

parisrv:
	make -C ./src
	mv ./src/parisv.so ./lib/GPP/parisv.so
	mv ./src/parisv.pm ./lib/GPP/parisv.pm

clean:
	make -C ./src clean

uberclean: clean
	rm -f ./lib/parisv.so
	rm -f ./lib/parisv.pm