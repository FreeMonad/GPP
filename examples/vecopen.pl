#!/usr/bin/env perl

use warnings;
use strict;

BEGIN { push @INC, './lib', './lib/GPP', '/usr/share/perl/5.10.1/Term'; }

use GPP;
use Term::ReadLine;

my $prompt = '(gpp)? ';

my $gpp = GPP->new( 'prompt' => $prompt );

$gpp->start();

my @test = $gpp->process_command('primes(10)');
my $primes = $test[0];
my @prime_array = open_parivec($primes);

foreach my $pr ( @prime_array ) {
  my $cmd = 'matid' . '(' . "$pr" . ')';
  my @mat = $gpp->process_command($cmd);
  print "$mat[0]", "\n";
}

$gpp->quit();

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

#EOF

