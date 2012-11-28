#!/usr/bin/env perl

use warnings;
use strict;

BEGIN { unshift @INC, './lib'; }

use Pari;

my $pari = Pari->new();
$pari->init();

my $default = '(gp)? ';
print_prompt($default);

while ( <> ) {
  my $expr = $_;

  if ( $expr =~ /quit\(\)/ ) {
    print "bye!", "\n";
    $pari->quit();
    exit(0);
  } else {
    my $out = $pari->evaluate($expr);
    my $hist = $pari->get_history_size();
    print_result($out,$hist);
    print_prompt($default);
  }
}

sub print_prompt {
  my $prompt = shift;
  print "$prompt";
}

sub print_result {
  my ( $out, $hist ) = @_;
  print ' %', "$hist", ' = ', "$out", "\n";
}

