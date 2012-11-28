#!/usr/bin/env perl

package Pari;

use warnings;
use strict;

use parisrv;

sub new {
  my $class = shift;
  my $self = { };
  bless $self, $class;
  return $self;
}

sub init {
  my $self = shift;
  parisrv::parisrv_init();
  $self->{'history_size'} = 0;
}

sub evaluate {
  my ($self, $expression ) = @_;
  my $result = parisrv::parisrv_eval("$expression");
  $self->{'history_size'} = parisrv::parisrv_nb_hist();
  return $result;
}

sub get_history_size {
  my $self = shift;
  return $self->{'history_size'};
}

sub quit {
  my $self = shift;
  parisrv::parisrv_close();
}

1;

