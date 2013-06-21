#!/usr/bin/env perl

use warnings;
use strict;

use GPP;

my $pari = GPP->new();

$pari->start();

init_curves(200);

$pari->quit();

sub init_curves {
  my ( $num_curves ) = @_;

  my $count = 0;

  while ( $count < $num_curves ) {
    my @seeds = ( 101, 1024, -41, 2011, 64 );
    my $arg = '[' . join( ',', map { int(rand($_)) } @seeds ) . ']';
    print "-"x50,"\n";
    print "\t",'ellinit('."$arg".')',"\n";
    print "-"x50,"\n";
    my $ell = $pari->ellinit($arg);
    print "$ell","\n";
    $count++;
  }
  print "-"x50,"\n";
}
