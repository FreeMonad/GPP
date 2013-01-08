#!/usr/bin/env perl

use warnings;
use strict;

use Cwd 'abs_path';
use Data::Dumper;

my $pari = $ARGV[0];

my $func_dir = "$pari" . '/src/functions';

die "$func_dir: no such directory"
  unless ( -d $func_dir );

chdir($func_dir);

my @sections = ( );

my @directories = ( 'elliptic_curves', 'linear_algebra', 'number_fields', 'number_theoretical', 'polynomials',
		     'sums', 'transcendental', 'conversions', 'programming' );

foreach my $dir ( @directories ) {
  my $section = { };
  $section->{name} = $dir;
  $section->{functions} = [];
  foreach my $file ( split( "\n", `/bin/ls -1 $dir`) ) {
    chdir($dir);
    my $function = extract_function(abs_path($file));
    push @{ $section->{functions} }, $function;
  }
  push @sections, $section;
  chdir($func_dir);
}

print_all();

sub print_all {
  foreach my $section ( @sections ) {
    print $section->{name},':',"\n";
    foreach my $function ( @{ $section->{functions} } ) {
      print "\t", $function->{id},':',"\n";
      foreach my $key ( keys %{ $function } ) {
	unless ( $key eq "id" ) {
	  print "\t","\t","$key = " . $function->{$key},"\n";
	}
      }
    }
  }
  print '='x10,"\n";
}

sub extract_function {
  my ( $file ) = @_;

  open ( my $FH, '<', "$file" )
    or die "failed to open $file: $!";

  my $function = { };

  foreach my $line ( <$FH> ) {
    chomp($line);
    if ( $line =~ /(Function)(\:\s)(\w+)/ ) {
      $function->{id} = $3;
    } elsif ( $line =~ /(Prototype)(\:\s)(\w+)/ ) {
      $function->{gp_args} = $3;
    } elsif ( $line =~ /(Help)(\:\s)(\w+)(\([^)]*\))(.*)/ ) {
      $function->{prototype} = $3 . $4;
    }
  }
  return $function;
}
