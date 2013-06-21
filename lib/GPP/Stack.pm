#!/usr/bin/env perl

package GPP::Stack;

use warnings;
use strict;

sub new {
  my ( $class ) = @_;

  my $self = {
	      'size' => 0,
	      'stack' => [],
	     };

  bless $self, $class;
  return $self;
}

sub get_size {
  my ( $self ) = @_;
  return $self->{size};
}

sub push_stack {
  my ( $self, $entry ) = @_;
  my $size = $self->get_size();
  push @{ $self->{stack} }, $entry;
  $self->{size} = $size + 1;
}

sub pop_stack {
  my ( $self ) = @_;
  my $size = $self->get_size();
  pop @{ $self->{stack} };
  $self->{size} = $size - 1;
}

sub peek {
    my ( $self ) = @_;
    my $size = $self->get_size();
    return $self->{'stack'}->[$size - 1];
}

sub get_element {
  my ( $self, $index ) = @_;
  my $size = $self->get_size();
  unless ( $index > $size || $index < 0 ) {
    my @stack = @{ $self->{stack} };
    return $stack[$index];
  } else {
    return 0;
  }
}



1;
