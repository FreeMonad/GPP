#!/usr/bin/env perl

use warnings;
use strict;

BEGIN { push @INC, './lib', './lib/GPP', '/usr/share/perl/5.10.1/Term'; }

use GPP;
use GPP::Meta;
use Term::ReadLine;

my $prompt = '(gpp)? ';

my $gpp = GPP->new( 'prompt' => $prompt );
my $meta = GPP::Meta->new();

my $term = Term::ReadLine->new("gpp");
my $OUT = $term->OUT || \*STDOUT;

print $OUT "\t",'GPP/PARI Calculator',"\n";
print_license();
print_help();
print $OUT "\n";

$gpp->start();

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

sub print_license {
  print $OUT
    'PARI/GP is free software, covered by the GNU General Public License,',"\n",
      'and comes WITHOUT ANY WARRANTY WHATSOEVER.',"\n";
}

sub print_help {
  print $OUT
    "\t",'Use ? to get help for a function',"\n";
}

#EOF

