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

my @primes = $gpp->process_command('primes(100)');
foreach my $prime ( @primes ) {
  print "$prime","\n";
}

while ( defined ( $_ = $term->readline($prompt))) {

  my $output = $gpp->process_command($_);
  my $result = $gpp->print_result($output);

  warn $@ if $@;
  print $OUT $result, "\n" unless $@;
}

#EOF
