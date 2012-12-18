#!/usr/bin/env perl

use warnings;
use strict;

BEGIN { push @INC, './lib', './lib/GPP', '/usr/share/perl/5.10.1/Term'; }

use GPP;
use Term::ReadLine;

my $prompt = '(gpp)? ';

my $gpp = GPP->new( 'prompt' => $prompt );

my $term = Term::ReadLine->new("gpp");
my $OUT = $term->OUT || \*STDOUT;
my ($columns, $rows) = $term->TermSize();

print "rows = $rows, columns = $columns","\n";

$gpp->start();

while ( defined ( $_ = $term->readline($prompt))) {

  my ( $output, $type ) = $gpp->process_command($_);
  my $history = $gpp->update_history();
  my $result;

  if ( $history ) {
    $result = '%' . "$history" . ' = ' . "\n" . "$output" . "\n\t" . '[' . "$type" . ']';
  } else {
    $result = "$output", "\n";
  }

  warn $@ if $@;
  print $OUT $result, "\n" unless $@;
}

#EOF

