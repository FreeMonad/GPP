#!/usr/bin/env perl

package Pari;

use warnings;
use strict;
use parisrv;

use Pari::History;

sub new {
  my $class = shift;
  my $self = {
	      'history' => Pari::History->new(),
	     };
  bless $self, $class;
  return $self;
}

sub init {
  my $self = shift;
  parisrv::parisrv_init();
}

sub evaluate {
  my ($self, $expression ) = @_;
  my $result = parisrv::parisrv_eval("$expression");
  $self->{'history'}->record_input("$expression");
  $self->{'history'}->set_history_size(parisrv::parisrv_nb_hist());
  return $result;
}

sub history_size {
  my $self = shift;
  return $self->{'history'}->get_history_size();
}

sub quit {
  my $self = shift;
  parisrv::parisrv_close();
}

1;
