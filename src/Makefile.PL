#!/usr/bin/env perl

use warnings;
use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
	      'NAME'  => 'GPP::Pari::Native',
	      'LIBS'  => '-lm -lpari',
	      'OBJECT' => 'parisv.o Native_wrap.o',
	     );
