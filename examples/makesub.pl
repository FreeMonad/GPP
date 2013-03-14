#!/usr/bin/env perl

use warnings;
use strict;

use File::Spec;
use GPP;

my $cwd = File::Spec->rel2abs(File::Spec->curdir());

my $gpp = GPP->new();

$gpp->start();

my $in_file = File::Spec->catfile( $cwd, 'config', 'funclist' );

open ( my $FH, '<', "$in_file" )
  or die "could not open $in_file: $!";

my @functions = ( );

my $href = { };

while ( <$FH> ) {
  my $line = $_;
  chomp($line);
  push @functions, $line;
}

close $FH;

foreach my $func ( @functions ) {
  my $func_sub = sub {
    my @args = @_;
    my $arg_str = join( '', @args );
    return $gpp->evaluate("$func".'('."$arg_str".')')->{output};
  };
  $href->{$func} = $func_sub;
}

my $primes_list = $href->{'primes'}->(20);
print "$primes_list","\n";

my $polgalois = $href->{'polgalois'}->('x^3-2');
print "$polgalois","\n";

while ( <> ) {
  my $str = $_;
  chomp($str);
  if ( $str =~ /(\w+)(.*)/i ) {
    my $cmd = $1;
    my $param = $2;
    $param =~ s/\(//;
    $param =~ s/\)//;
    my @params = split ( /,?\s+/, $param );
    my $usercmd = $href->{$cmd}->(@params);
    print "$usercmd","\n";
  } else {
    my $usercmd = $href->{$str}->();
    print "$usercmd","\n";
  }
}

$gpp->quit();
