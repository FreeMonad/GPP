#!/usr/bin/env perl

package GPP::Pari;

use warnings;
use strict;
use parisrv;

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
  parisrv::parisrv_init();
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
  my ($self, $expression ) = @_;
  my $result = parisrv::parisrv_eval("$expression");
  return $result;
}

sub history_size {
  my $self = shift;
  return parisrv::parisrv_nb_hist();
}

sub quit {
  my $self = shift;
  parisrv::parisrv_close();
}

1;
