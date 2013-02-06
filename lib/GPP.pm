#!/usr/bin/env perl

package GPP;

use warnings;
use strict;

use GPP::Pari;
use GPP::Stack;

sub new {
  my $class = shift;
  my %opts = @_;
  my $self = {
	      'pari' => $opts{'pari'} || GPP::Pari->new( 'max_prime' => 500509),
	      'prompt' => $opts{'prompt'} || '(gpp)? ',
	      'stack' => $opts{'stack'} || GPP::Stack->new(),
	      'histsize_cache' => 0,
	     };
  bless $self, $class;
  return $self;
}

sub start {
  my $self = shift;
  $self->{'pari'}->init();
}

sub evaluate {
  my ( $self, $expr ) = @_;

  chomp( $expr );

  my( $pari, $stack ) = ( $self->{'pari'}, $self->{stack} );

  my $histsize_cache = $self->history_size();

  my $result = { };

  if ( $expr =~ /quit\(\)/ || $expr =~ /quit/ ) {
    $self->quit();
  }
  elsif ( $expr =~ /(\?{1,2})([a-z]+)/g ) {
    my $help = 'help(' . "$2" . ')';
    $result->{input} = "$help";
    $result->{output} = $pari->evaluate_cmd($help);
    $result->{type} = '_HELP_';
  }
  elsif ( $expr =~ /version\(\)/ ) {
    $result->{input} = "$expr";
    $result->{output} = $self->get_version();
    $result->{type} = 't_STR';
  }
  elsif ( $expr =~ /^\\.*/ ){
    $result->{input} = "$expr";
    $result->{output} = $self->escape("$expr");
    $result->{type} = '_META_';
  }
  else {
    $result->{input} = "$expr";
    $result->{output} = $pari->evaluate_cmd($expr);
    $result->{type} = $pari->result_type($expr);
  }

  my $histsize = $self->history_size();

  unless ( $histsize <= $histsize_cache ) {
    $result->{history} = $histsize;
  } else {
    $result->{history} = '';
  }

  $stack->push_stack($result);
  return $result;
}

sub escape {
  my ( $self, $expr ) = @_;

  my $pari = $self->{'pari'};

  if ( $expr =~ /^(\\)(q)/ ) {
    $self->quit();
  }
  elsif ( $expr =~ /^(\\)(v)/ ) {
    return $self->get_version();
  }
  elsif ( $expr =~ /^(\\)(s)(\d+)/ ) {
    return $self->{stack}->get_element($2);
  }
  elsif ( $expr =~ /^(\\)(e)(.*)/ ) {
    return ( eval($3) );
  }
  elsif ( $expr =~ /^(\\)(.*)/ ) {
    return $pari->escape_cmd("$1"."$2");
  }
  else {
    return "";
  }
}

sub history_size {
  my ( $self ) = @_;
  return $self->{'pari'}->history_size();
}

sub cached_histsize {
  my ( $self ) = @_;
  return $self->{'histsize_cache'};
}

sub get_version {
  my ( $self ) = @_;
  return $self->{pari}->{version};
}

sub get_prompt {
  my ( $self ) = @_;
  return $self->{'prompt'};
}

sub set_prompt {
  my ( $self, $prompt ) = @_;
  $self->{'prompt'} = "$prompt";
  return $prompt;
}

sub get_stack {
  my ( $self ) = @_;
  return $self->{'stack'};
}

sub license {
  my $license = join ( "\n",
		       (
			'PARI/GP is free software, covered by the GNU General Public License, and comes WITHOUT ANY WARRANTY WHATSOEVER',
			'Copyright (C) 2000-2013 The PARI Group'
		       )
		     );
  return $license;
}

sub quit {
  my ( $self ) = @_;
  print "bye!", "\n";
  $self->{'pari'}->quit();
  exit(0);
}

1;
