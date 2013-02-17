#!/usr/bin/env perl

use warnings;
use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
	      'NAME' => 'GPP',
	      'VERSION_FROM' => 'lib/GPP.pm',
	      'ABSTRACT' => 'a simple and extensible library for using Pari/GP in Perl scripts',
	      'AUTHOR'   => 'Charles Boyd <charles.boyd@freemonad.org>',
	     );
