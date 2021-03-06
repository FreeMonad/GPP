#!/usr/bin/env perl

use warnings;
use strict;

use GPP;
use File::Spec;

my $pari = GPP->new();

$pari->start();

cremona();

$pari->quit();

sub cremona {

  my $cwd = File::Spec->curdir();
  my $data = File::Spec->catdir($cwd,'examples','data');
  my $file = File::Spec->catfile($data,'cremona.txt');;

  open ( my $FH, '<', $file)
    or die "open $file: $!";

  print '='x40,"\n";

  while ( <$FH> ) {
    my $line = $_;
    chomp($line);
    $line =~ s/\]\s/\]\, /;
    my $new_line = join ( "", split( " ", $line ));

    if ( $new_line =~ /^(\d+\w\d)(.*)/ ) {
      my $curve_name = $1;
      print "E = $curve_name","\n";;
      my $curve_data = $2;
      my $args = '"' . "$curve_name" .'"';
      my $ell = ellinit($args);
      print "$ell","\n";
      my $entry = '[' . "$curve_name" . ',' . "$curve_data" . ']';
      $entry =~ s/\]\]\[\[/\]\],\[\[/;
      print "$entry","\n";
      print '='x40,"\n";
    }
  }
}

sub evaluate {
  my ( $cmd ) = @_;
  return $pari->evaluate("$cmd")->{output};
}

sub ellinit {
 my ( $params ) = @_;
 my $cmd = 'ellinit' . '(' . "$params" . ')';
 return evaluate($cmd);
}
