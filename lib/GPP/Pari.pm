#!/usr/bin/env perl

package GPP::Pari;

use warnings;
use strict;

use GPP::Pari::Native;

sub new {
  my $class = shift;
  my %opts = @_;

  my $pari_size = $opts{'pari_size'} // undef;
  my $max_prime = $opts{'prime_limit'} // undef;
  my $real_precision = $opts{'real_precision'} // undef;
  my $series_precision = $opts{'series_precision'} // undef;

  my $self = {
	      'pari_size' => $pari_size,
	      'max_prime' => $max_prime,
	      'real_precision' => $real_precision,
	      'series_precision' => $series_precision,
	     };

  bless ( $self, $class );
  return $self;
}

sub init {
  my ( $self ) = @_;

  GPP::Pari::Native::parisv_init();

  $self->{version} = $self->set_version($self->evaluate_cmd('version()'));

  if ( $self->{pari_size} ) { $self->set_default('parisize', $self->{pari_size}); }
  if ( $self->{real_precision} ) { $self->set_default('realprecision', $self->{real_precision}); }
  if ( $self->{series_precision} ) { $self->set_default('seriesprecision', $self->{series_precision}); }
}

sub get_version {
  my ( $self ) = @_;
  return $self->{'version'};
}

sub set_version {
  my ( $self, $pari_version ) = @_;

  chomp($pari_version);
  $pari_version =~ s/^\[//;
  $pari_version =~ s/\]$//;
  $pari_version =~ s/\s+//g;

  my ( $vers, $major, $minor, $branch ) = split( ',', $pari_version );

  my $version =  join ( '.', ( $vers, $major, $minor ) );

  if ( $branch ) {
    $branch =~ s/\"//g;
    return 'Version ' . $version . " ( development $branch )";
  } else {
    return 'Version ' . $version . ' ( release )';
  }
}

sub set_default {
  my ( $self, $key, $value ) = @_;

  unless ( $value ) {
    return $self->evaluate_cmd("default($key)");
  }
  $self->evaluate_cmd("default($key,$value)");
  return $self->evaluate_cmd("default($key)");
}

sub evaluate_cmd {
  my ( $self, $expression ) = @_;
  my $result = GPP::Pari::Native::evaluate("$expression");
  return $result;
}

sub escape_cmd {
  my ( $self, $escape_command ) = @_;
  return "$escape_command - not implemented";
}

sub result_type {
  my ( $self, $expression ) = @_;
  my $type = GPP::Pari::Native::parisv_type("$expression");
  return $type;
}

sub history_size {
  my $self = shift;
  return GPP::Pari::Native::parisv_nb_hist();
}

sub quit {
  my $self = shift;
  GPP::Pari::Native::quit();
}

1;
