#!/usr/bin/env perl

package GPP::Pari;

use warnings;
use strict;
use parisv;

sub new {
  my $class = shift;
  my %opts = @_;

  my $pari_size = $opts{'pari_size'} || undef;
  my $max_prime = $opts{'max_prime'} || undef;
  my $real_precision = $opts{'real_precision'} || undef;
  my $series_precision = $opts{'series_precision'} || undef;

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
  my $self = shift;
  parisv::parisv_init();
  if ( $self->{pari_size} ) { $self->set_default('parisize', $self->{pari_size}); }
  if ( $self->{real_precision} ) { $self->set_default('realprecision', $self->{real_precision}); }
  if ( $self->{series_precision} ) { $self->set_default('seriesprecision', $self->{series_precision}); }
}

sub set_default {
  my ( $self, $key, $value ) = @_;
  $self->evaluate("default($key,$value)");
  return $self->evaluate("default($key)");
}

sub evaluate {
  my ( $self, $expression ) = @_;
  my $result = parisv::evaluate("$expression");
  return $result;
}

sub type {
  my ( $self, $expression ) = @_;
  my $type = parisv::parisv_type("$expression");
  return $type;
}

sub history_size {
  my $self = shift;
  return parisv::parisv_nb_hist();
}

sub quit {
  my $self = shift;
  parisv::quit();
}

1;
