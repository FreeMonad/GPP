#!/usr/bin/env perl

package GPP;

use warnings;
use strict;

use GPP::Pari;

sub new {
  my $class = shift;
  my %opts = @_;
  my $self = {
	      'pari' => $opts{'pari'} || GPP::Pari->new( 'max_prime' => 500509),
	      'prompt' => $opts{'prompt'} || '(gpp)? ',
	      'histsize_cache' => 0,
	     };
  bless $self, $class;
  return $self;
}

sub start {
  my $self = shift;
  $self->{'pari'}->init();
}

sub get_prompt {
  my $self = shift;
  return $self->{'prompt'};
}

sub process_command {
  my ( $self, $expr ) = @_;
  my $pari = $self->{'pari'};

  $self->{'histsize_cache'} = $pari->history_size();

  if ( $expr =~ /quit\(\)/ || $expr =~ /quit/ || $expr =~ /\\q/ ) {
    $self->quit();
  } elsif ( $expr =~ /(\?{1,2})([a-z]+)/g ) {
    my $help = 'help(' . "$2" . ')';
    return $pari->evaluate($help);
  } else {
    return $pari->evaluate($expr);
  }
}

sub quit {
  my $self = shift;
  print "bye!", "\n";
  $self->{'pari'}->quit();
  exit(0);
}


sub print_result {
  my ( $self, $output ) = @_;
  my $pari = $self->{'pari'};
  my $histsize_cache = $self->{'histsize_cache'};
  my $pari_histsize = $pari->history_size();
  my $result = '';

  if ( $histsize_cache < $pari_histsize ) {
    $self->{'histsize_cache'} = $pari_histsize;
    $result = ' %' . "$pari_histsize" . ' = ' . "$output", "\n";
  } else {
    $result = ' ' . "$output", "\n";
  }
  return $result;
}

1;
