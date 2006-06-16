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
	$NUMTESTS = 47;
	plan tests => $NUMTESTS;
	eval { require Graph; };
	if ($@) {
		warn "Perl's Graph needed for the bioperl-network package, skipping tests";
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
require Bio::Network::IO;
require Bio::Network::Interaction;

my $verbose = 0;
$verbose = 1 if $DEBUG;

# tests for Graph's problematic articulation_points()

ok 1;

#
# read old DIP format
#
my $io = Bio::Network::IO->new(
  -format => 'dip_tab',
  -file   => Bio::Root::IO->catfile("t","data","tab1part.tab"),
  -threshold => 0.6);
ok(defined $io);
ok my $g1 = $io->next_network();

my @nodes = $g1->articulation_points();
ok $#nodes, 12;
my $nodes = $g1->articulation_points();
ok $nodes, 13;
#
# test articulation_points, but first check that each Node
# in network can load...
#
$io = Bio::Network::IO->new
(-format => 'psi',
 -file   => Bio::Root::IO->catfile("t","data","bovin_small_intact.xml"));
my $g = $io->next_network();

@nodes = $g->nodes;
ok scalar @nodes, 23;
foreach my $node (@nodes) {
	my @seqs = $nodes[0]->proteins;
	ok $seqs[0]->display_id;
}

# ($ap, $bc, $br) = $g->biconnectivity;

@nodes = $g->articulation_points;
ok scalar @nodes, 4; # OK, inspected in Cytoscape

my @eids = qw(EBI-307814 EBI-79764 EBI-620432 EBI-620400);
my @seqs = $nodes[0]->proteins; # Node not always loaded
my $id = $seqs[0]->display_id;
ok grep /$id/, @eids;
@seqs = $nodes[1]->proteins; # Node not always loaded
$id = $seqs[0]->display_id;
ok grep /$id/, @eids;
@seqs = $nodes[2]->proteins; # Node not always loaded
$id = $seqs[0]->display_id;
ok grep /$id/, @eids;
@seqs = $nodes[3]->proteins; # Node not always loaded
$id = $seqs[0]->display_id;
ok grep /$id/, @eids;
#
# additional articulation_points tests
# arath_small-02.xml is PSI MI version 1.0
#
ok $io = Bio::Network::IO->new
  (-format => 'psi',
	-file   => Bio::Root::IO->catfile("t", "data", "arath_small-02.xml"));
ok $g1 = $io->next_network();
ok $g1->nodes, 73;
ok $g1->interactions, 516;
@nodes = $g1->articulation_points;
ok scalar @nodes, 8;
my @ids = qw(EBI-621930 EBI-622235 EBI-622281 EBI-622140 
			  EBI-622382 EBI-622306 EBI-622264 EBI-622203 );
for my $node (@nodes) {
	for my $prot ($node->proteins) {
		my $id = $prot->display_id;
		ok grep /$id/,@ids;
	}
}

__END__

