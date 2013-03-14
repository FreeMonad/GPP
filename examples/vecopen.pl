#!/usr/bin/env perl

use warnings;
use strict;

use GPP;

my $prompt = '(gpp)? ';

my $gpp = GPP->new( 'prompt' => $prompt );

$gpp->start();

evaluate('default(output,0)');

my $bnf = evaluate('bnfinit(x^3-2)');
my @bnf_matrix = open_parimat($bnf);
print_matrix(@bnf_matrix);

$gpp->quit();

sub evaluate {
  my ( $cmd ) = @_;
  return $gpp->evaluate("$cmd")->{output};
}

sub open_parivec {
  my $vec = shift;
  $vec =~ s/(\[)(\w+)/$2/;
  $vec =~ s/(\w+)(\])/$1/;
  $vec =~ s/(\s+)(',')(\s+)/$2/;

  my @elems = split( ',' , $vec );
  my @array = ();

  foreach my $x ( @elems ) {
    push @array, $x;
  }
  return @array;
}

sub open_parimat {
  my $mat_str = shift;
  my @matrix;
  $mat_str =~ s/(\[)(\w+)/$2/;
  $mat_str =~ s/(\w+)(\])/$1/;
  my @rows = split( ';', $mat_str );
  foreach my $row ( @rows ) {
    push @matrix, [ $row ];
  }
  return @matrix;
}

sub print_matrix {
  my @mat = @_;
  foreach my $aref ( @mat ) {
    print "\t [ @$aref ]","\n";
  }
}

#EOF

