#!/usr/bin/env perl

use warnings;
use strict;

BEGIN { unshift @INC, './lib'; }

use GPP;

my $prompt = '(gp)? ';

my $gpp = GPP->new( 'prompt' => $prompt );

$gpp->start();

while ( <> ) {
  my $out = $gpp->process_command($_);
  if ( $out ) {  $gpp->print_result($out); }
  $gpp->print_prompt();
}

#EOF
