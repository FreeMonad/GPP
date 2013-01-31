#!/usr/bin/env perl

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
  print $OUT $gpp->get_version(), "\n";
  print $OUT "\n";
}

sub update_prompt {
  return strftime( "$prompt", localtime(time) );
}

#EOF

