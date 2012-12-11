.PHONY: all parisrv clean

all: parisrv

parisrv:
	make -C ./src
	mv ./src/parisrv.so ./lib/GPP/parisrv.so
	mv ./src/parisrv.pm ./lib/GPP/parisrv.pm

clean:
	make -C ./src clean

uberclean: clean
	rm -f ./lib/parisrv.so
	rm -f ./lib/parisrv.pm