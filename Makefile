.PHONY: all parisrv clean

all: parisrv install

parisrv:
	make -C ./src
	mv ./src/parisv.so ./lib/GPP/parisv.so
	mv ./src/parisv.pm ./lib/GPP/parisv.pm

install:
	ln -s ./bin/gpp.pl ./gpp
	ln -s ./bin/gui.pl ./gui

clean:
	make -C ./src clean
	rm -f ./gpp
	rm -f ./gui

uberclean: clean
	rm -f ./lib/parisv.so
	rm -f ./lib/parisv.pm
