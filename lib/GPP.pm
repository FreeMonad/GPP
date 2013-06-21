package GPP;

use warnings;
use strict;

use Carp;
use YAML::XS qw( Dump LoadFile);

use GPP::Pari;
use GPP::Stack;

use version; our $VERSION = qv(0.1.5);

our $AUTOLOAD;

sub AUTOLOAD {
    my $self = shift or return undef;

    # Get the called method name and trim off the fully-qualified part
    ( my $method = $AUTOLOAD ) =~ s{.*::}{};

    if ( ! exists $self->{$method} ) {
	print "loading method...: ","$method","\n";
    }

    ### Create a closure that will become the new accessor method
    my $accessor = sub {
	my $closure_self = shift;

	if ( @_ ) {
	    return $closure_self->evaluate( $method, @_);
	}
	return $closure_self->evaluate( $method );
    };

    # assign the closure to symbol table
  SYMBOL_TABLE_HACK: {
	no strict qw{refs};
	*$AUTOLOAD = $accessor;
    }

    # Turn the call back into a method call by sticking the self-reference
    # back onto the arglist
    unshift @_, $self;

    # Jump to the newly-created method with magic goto
    goto &$AUTOLOAD;
}

sub new {
    my $class = shift;
    my %opts = @_;

    my %pari_args = (
	'prime_limit' => $opts{'prime_limit'} // 500509,
    );

    my $self = {
	'pari'     => GPP::Pari->new( %pari_args ),
	'prompt'   => $opts{'prompt'} // '(gpp)? ',
	'funclist' => $opts{'funclist'} // [ 'factor', 'primes' ],
    };

    $self->{'stack'} = GPP::Stack->new();
    $self->{'histsize_cache'} = 0;
    bless $self, $class;

    foreach my $method ( @{ $self->{'funclist'} } ) {
	my $f = sub {
	    my $closure_self = shift;

	    if ( @_ ) {
		return $closure_self->evaluate( $method, @_ );
	    }
	    return $closure_self->evaluate( $method );
	};

      SYMBOL_TABLE_INSERT: {
	    no strict qw{refs};
	    *$method = $f;
	}
	print 'created method ',"$method","\n";
	$self = bless($self);
    }
    return $self;
}

sub start {
    my $self = shift;
    $self->{'pari'}->init();
}

sub evaluate {
    my ( $self, $cmd, @args ) = @_;

    chomp( $cmd );

    if ( @args ) {
	$cmd .= '(' . join( ',', @args ) . ')';
    }

    $self->{'histsize_cache'} = $self->history_size();

    if ( $cmd =~ /^(\?)(.*)/ ) {
	my $func = $2;
	my $help_cmd = {
	    'input'  => $cmd,
	    'output' => $self->help($func),
	    'type'   => 't_HELP',
	};
	return $self->add_history($help_cmd);
    } elsif ( $cmd =~ /version/ ) {
	my $version_cmd = {
	    'input'  => $cmd,
	    'output' => $self->get_version(),
	    'type'   => 't_STR',
	};
	return $self->add_history($version_cmd);
    } elsif ( $cmd =~ /^\\.*/ ) {
	my $meta_cmd = {
	    'input'  => $cmd,
	    'output' => $self->escape($cmd),
	    'type'   => 'META',
	};
	return $self->add_history($meta_cmd);
    } else {
	my $pari_cmd = {
	    'input'  => $cmd,
	    'output' => $self->{'pari'}->evaluate_cmd($cmd),
	    'type'   => $self->{'pari'}->result_type($cmd),
	};
	return $self->add_history($pari_cmd);
    }
}

sub escape {
    my ( $self, $expr ) = @_;

    my $pari = $self->{'pari'};

    if ( $expr =~ /^(\\)(q)/ ) {
	return $self->quit();
    } elsif ( $expr =~ /^(\\)(v)/ ) {
	return $self->get_version();
    } elsif ( $expr =~ /^(\\)(.*)/ ) {
	return $pari->escape_cmd("$1"."$2");
    } else {
	return undef;
    }
}

sub add_history {
    my ( $self, $result ) = @_;

    my $histsize = $self->history_size();

    unless ( $histsize <= $self->{'histsize_cache'} ) {
	$result->{history} = $histsize;
    } else {
	$result->{history} = '';
    }
    $self->{'stack'}->push_stack($result);
    return $result->{'output'};
}

sub help {
    my ( $self, $func ) = @_;
    my $cmd = 'help(\$func)';
    return $self->{'pari'}->evaluate_cmd($cmd);
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
}

sub DESTROY {
    my ( $self ) = @_;
    $self->{'pari'} = undef;
}

1;
