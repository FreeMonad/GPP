#!/usr/bin/env perl

use warnings;
use strict;

use GPP;

my $pari = GPP->new();

$pari->start();
$pari->evaluate('default(output, 0)');

my @test_values = ( );

for ( 1 .. 100 ) {
  push @test_values, int(rand( 10000 ));
}

foreach my $val ( @test_values ) {
print '-'x20,"\n";
  print "N = $val","\n";
  print '-'x20,"\n";
  foreach my $factor ( primefactors($val) ) {
    print "\t","$factor","\n";
  }
}

sub primefactors {
  my ( $element ) = @_;

  my $result = evaluate("vecextract(factor($element), 1)");

  my @prime_factors = ();

  unless ( $result =~ /Mat\(\d+\)/ ) {
    chomp($result);
    $result =~ s/^\[//;
    $result =~ s/\]$//;
    @prime_factors = split( ';', $result );
  } else {
    @prime_factors = ( $element );
  }
  return @prime_factors;
}

sub evaluate {
  my ( $cmd ) = @_;
  return $pari->evaluate("$cmd")->{output};
}

$pari->quit();
