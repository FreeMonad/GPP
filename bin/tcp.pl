#!/usr/bin/env perl

use GPP;
use IO::Socket;
use Net::hostent;
use POSIX qw/strftime/;

# TCP Port
$PORT = 9000;

# Create Socket Instance
$socket = IO::Socket::INET->new(
				Proto     => 'tcp',
				LocalPort => $PORT,
				Listen    => SOMAXCONN,
				Reuse     => 1
			       );

my $prompt = '[%H:%M] (gpp)? ';

die "can't setup server"
  unless $socket;

print "[Server $0 accepting clients]\015\012";

while ( $client = $socket->accept() ) {

  $client->autoflush(1);

  print $client "GPP listening on $PORT\n";
  $hostinfo = gethostbyaddr($client->peeraddr);
  printf "[Connect from %s]\015\012", $hostinfo->name || $client->peerhost;
  print $client update_prompt();
  my $gpp = GPP->new();
  $gpp->start();
  while ( <$client>) {
    next unless /\S/;
    my $result = $gpp->evaluate($_);
    my $output = join( "", ('%', $result->{history}, ' = ', "\n", $result->{output}, "\n\n") );
    print $client "$output";
  } continue {
    print $client update_prompt();
  }
  print "closing...\n";
}

sub update_prompt {
  return strftime( "$prompt", localtime(time) );
}
