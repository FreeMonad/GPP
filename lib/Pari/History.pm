#!/usr/bin/env perl

package Pari::History;

use warnings;
use strict;

sub new {
  my $class = shift;

  my $self = {
	      'history_size' => 0,
	      'input' => [],
	     };

  bless $self, $class;
  return $self;
}

sub set_history_size {
  my ( $self, $size ) = @_;
  $self->{'history_size'} = $size;
}

sub get_history_size {
  my ( $self ) = @_;
  return $self->{'history_size'};
}

# TODO
sub record_input {
  my ( $self, $command ) = @_;
  return 0;
}

1;
