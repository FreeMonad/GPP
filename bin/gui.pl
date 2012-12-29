#!/usr/bin/env perl

BEGIN { push @INC, './lib', './lib/GPP'; }

use GPP;
use XUL::Gui;

my $gpp = GPP->new();

$gpp->start();

my $counter = 0;

my @commands = ();

display Window
  title     => 'GP-XUL',
  minheight => 300,
  Hbox( MIDDLE,
	TextBox(
		id => 'input',
		label => 'prompt',
		value => 'fibonacci(2)',
	       ),
	Button(
	       id => 'eval',
	       label     => 'run',
	       oncommand => sub {
		 my $cmd = ID(input)->value;
		 my $result = evaluate($cmd);
		 ID(txt)->appendChild(
				      TextBox(
					      FILL SCROLL id => 'out' . "$counter",
					      label => 'output',
					      value => "$result",
					      multiline => 'true'
					     ),
				     );
		 $counter++;
	       }
	      ),
	BR(),
	Button(
	       id => 'prev',
	       label => 'prev',
	       oncommand => sub {
		 my $hist_elt = pop @commands;
		 ID(input)->value = $hist_elt;
	       }
	      ),
      ),
  Stack( id => 'txt', orient => 'vertical' );

sub evaluate {
  my ($cmd) = @_;
  my ( $output, $type ) = $gpp->process_command($cmd);
  my $history = $gpp->update_history();
  if ( $history ) {
    push ( @commands, $cmd );
    return '%' . "$history" . ' = ' . "\n" . "$output" . "\n\t" . '[' . "$type" . ']';
  } else {
    return "$output", "\n";
  }
  return 0;
}

