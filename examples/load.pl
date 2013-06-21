#!/usr/bin/perl

use warnings;
use strict;

use GPP;
use YAML::XS qw(LoadFile);

my @function_list = ( 'polgalois', 'fibonacci' );

foreach ( qw{ ./functions/elliptic_curves.yml ./functions/linear_algebra.yml } ) {
    my @data = LoadFile($_);
    foreach my $func_desc ( @data ) {
	push( @function_list, $func_desc->{'id'} );
    }
}

my $gpp = GPP->new( 'funclist' => \@function_list );

$gpp->start();

print $gpp->polgalois('x^3-2'),"\n";
print $gpp->prime(2123),"\n";
print $gpp->fibonacci(20),"\n";
print $gpp->foo(2),"\n";

$gpp->quit();

#EOF

