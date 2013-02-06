#!/usr/bin/env perl
################################################################################
#   gpp - an interactive command line interface for Pari/GP, written in perl
#                  Copyright (C) 2013 Charles Boyd
################################################################################
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
################################################################################

use warnings;
use strict;

BEGIN { push @INC, './lib', './lib/GPP', '/usr/share/perl/5.10.1/Term'; }

use GPP;
use Term::ReadLine;
use POSIX qw(strftime);

my $prompt = '[%H:%M] (gpp)? ';

my $gpp = GPP->new( 'prompt' => $prompt);

$gpp->start();

my $term = Term::ReadLine->new("gpp");
my $OUT = $term->OUT || \*STDOUT;

gpp_header();

while ( defined ( $_ = $term->readline( update_prompt() ) ) ) {

  my $result = $gpp->evaluate($_);

  warn $@ if $@;

  my $output = join( "", ('%', $result->{history}, ' = ', "\n", $result->{output}, "\n\n") );

  print $OUT "$output"
    unless $@;
}

sub gpp_header {
  print $OUT 'GPP/PARI CALCULATOR - ';
  print $OUT $gpp->license(), "\n";
  print $OUT $gpp->get_version(), "\n";
  print $OUT "\n";
}

sub update_prompt {
  return strftime( "$prompt", localtime(time) );
}

#EOF

