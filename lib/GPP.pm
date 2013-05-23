#!/usr/bin/env perl

package GPP;

use warnings;
use strict;

use GPP::Pari;
use GPP::Stack;

use version; our $VERSION = qv(0.1.5);

sub new {
    my $class = shift;
    my %opts = @_;
    my $self = {
	'disable_eval' => $opts{'disable_eval'} || 0,
	'pari' => $opts{'pari'} || GPP::Pari->new( 'max_prime' => $opts{'prime_limit'} ),
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

    my $result = { };

    if ( $self->{'paused'} ) {
	if ( $self->{'paused'} && $expr =~ qr/resume/ ) {
	    $result->{input} = $expr;
	    $result->{output} = $self->resume();
	    $result->{type}   = '_META_';
	    return $result;
	}
	elsif ( $expr !~ qr/resume/ ) {
	    $result->{input} = $expr;
	    $result->{output} = 'paused: please resume() to continue';
	    $result->{type}   = '_META_';
	    return $result;
	}
	else {
	    die 'unknown state';
	}
    }


    my( $pari, $stack ) = ( $self->{'pari'}, $self->{stack} );

    my $histsize_cache = $self->history_size();

    if ( $expr =~ /quit\(\)/ || $expr =~ /quit/ ) {
	$self->quit();
    } elsif ( $expr =~ /(\?{1,2})([a-z]+)/g ) {
	my $help = 'help(' . "$2" . ')';
	$result->{input} = "$help";
	$result->{output} = $pari->evaluate_cmd($help) // 'paused';
	$result->{type} = '_HELP_';
    } elsif ( $expr =~ /version\(\)/ ) {
	$result->{input} = "$expr";
	$result->{output} = $self->get_version();
	$result->{type} = 't_STR';
    } elsif ( $expr =~ /pause/ ) {
	$result->{input} = 'pause()';
	$result->{output} = $self->pause();
	$result->{type}   = '_META_';
    } elsif ( $expr =~ /resume/ ) {
	$result->{input} = 'resume()';
    } elsif ( $expr =~ /^\\.*/ ) {
	$result->{input} = "$expr";
	$result->{output} = $self->escape("$expr");
	$result->{type} = '_META_';
    } else {
	$result->{input} = "$expr";
	$result->{output} = $pari->evaluate_cmd($expr) // 'paused';
	$result->{type} = $pari->result_type($expr) // 'paused';
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
    } elsif ( $expr =~ /^(\\)(v)/ ) {
	return $self->get_version();
    } elsif ( $expr =~ /^(\\)(s)(\d+)/ ) {
	return $self->{stack}->get_element($2);
    } elsif ( $expr =~ /^(\\)(e)(.*)/ ) {
	return $self->{'disable_eval'} || ( eval($3) );
    } elsif ( $expr =~ /^(\\)(.*)/ ) {
	return $pari->escape_cmd("$1"."$2") // 'paused';
    } else {
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

sub pause {
    my ( $self ) = @_;
    if ( ! $self->{'paused'} ) {
	$self->{'pari'}->quit();
	$self->{'paused'} = 1;
	return 'paused';
    }
    return 0;
}

sub resume {
    my ( $self ) = @_;
    if ( $self->{'paused'} ) {
	$self->{'pari'} = undef;
	$self->{'pari'} = GPP::Pari->new();
	$self->{'pari'}->init();
	$self->{'paused'} = 0;
	return 'resumed';
    }
    return 0;
}

sub reload {
    my ( $self ) = @_;
    $self->{'pari'}->quit();
    $self->{'pari'} = GPP::Pari->new();
    $self->{'pari'}->init();
    $self->{'stack'} = GPP::Stack->new();
    $self->{'histsize_cache'} = 0;
}

sub quit {
    my ( $self ) = @_;
    print "bye!", "\n";
    $self->{'pari'}->quit();
    exit(0);
}

1;
