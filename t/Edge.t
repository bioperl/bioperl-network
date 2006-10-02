# This is -*-Perl-*- code#
# Bioperl Test Harness Script for Modules
# $Id: protgraph.t,v 1.1 2004/03/13 23:45:32 radams Exp

use vars qw($NUMTESTS $DEBUG $ERROR);
use strict;
$DEBUG = $ENV{'BIOPERLDEBUG'} || 0;

BEGIN {
	# to handle systems with no installed Test module
	# we include the t dir (where a copy of Test.pm is located)
	# as a fallback
	eval { require Test; };
	$ERROR = 0;
	if ( $@ ) {
		use lib 't';
	}
	use Test;
	$NUMTESTS = 7;
	plan tests => $NUMTESTS;
	eval { require Graph; };
	if ($@) {
		warn "Graph module needed for the bioperl-network package, skipping tests";
		$ERROR = 1;
	}
}

END {
	foreach ( $Test::ntest..$NUMTESTS) {
		skip("Missing dependencies. Skipping tests",1);
	}
}

exit 0 if $ERROR ==  1;

require Bio::Network::ProteinNet;
require Bio::Network::Edge;
require Bio::Network::Node;
require Bio::Seq;

my $verbose = 0;
$verbose = 1 if $DEBUG;

ok 1;

my $seq1 = Bio::Seq->new(-seq => "aaaaaaa");
my $seq2 = Bio::Seq->new(-seq => "ttttttt");
my $seq3 = Bio::Seq->new(-seq => "ccccccc");

my $node1 = Bio::Network::Node->new(-protein => $seq1);
my $node2 = Bio::Network::Node->new(-protein => [($seq2,$seq3)]);

my $edge = Bio::Network::Edge->new(-nodes => [($node1,$node2)]);
ok 1;
my $count = $edge->nodes;
ok $count, 2;

my @nodes = $edge->nodes;
ok $#nodes, 1;

# suppose that it's possible to construct an Edge with 1 Node,
# interacting with itself
$edge = Bio::Network::Edge->new(-nodes => [($node1)]);
ok 1;
$count = $edge->nodes;
ok $count, 1;

@nodes = $edge->nodes;
ok scalar @nodes, 1;

__END__

