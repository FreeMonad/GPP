#!/usr/bin/env perl

use warnings;
use strict;

BEGIN { push @INC, './lib', './lib/GPP', '/usr/share/perl/5.10.1/Term'; }

use GPP;
use Term::ReadLine;

my $prompt = '(gpp)? ';

my $gpp = GPP->new( 'prompt' => $prompt);

$gpp->start();

my $term = Term::ReadLine->new("gpp");
my $OUT = $term->OUT || \*STDOUT;

print_version();

while ( defined ( $_ = $term->readline($prompt))) {

  my ( $output, $type ) = $gpp->process_command($_);
  my $history = $gpp->update_history();

  warn $@ if $@;

  if ( $history ) {
    print $OUT '%' . "$history" . ' = ' . "\n" . "$output" . "\n\t" . '[' . "$type" . ']', "\n"
      unless $@;
  } else {
    print $OUT "$output", "\n"
      unless $@;
  }
}

sub print_version {
  print $OUT 'GPP/PARI CALCULATOR - ';
  print $OUT $gpp->get_version(), "\n";
  print $OUT "\n";
}

#EOF

