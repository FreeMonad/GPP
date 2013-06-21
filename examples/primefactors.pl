#!/usr/bin/env perl

use warnings;
use strict;

use GPP;

my $gpp = GPP->new();

$gpp->start();

$gpp->default('output','0');

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

    my $factorization = $gpp->factor( $element );
    my $result = $gpp->vecextract( $factorization, 1 );

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

$gpp->quit();
