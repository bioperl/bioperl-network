# This is -*-Perl-*- code#
# Bioperl Test Harness Script for Modules
# $Id: Node.t 14466 2008-02-04 05:15:58Z bosborne $

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
	$NUMTESTS = 51;
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

exit 0 if $ERROR == 1;

require Bio::Network::IO;

my $verbose = 0;
$verbose = 1 if $DEBUG;

# tests for Graph's problematic articulation_points()
# As of 2/2008 this test suite is still not reliably passing -
# I run it 5 times and I'll get an error 1 out of 5:
# Can't locate object method "proteins" via package "Bio::Network::Node...

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
# in network exists as an object
#
$io = Bio::Network::IO->new
(-format => 'psi10',
 -file   => Bio::Root::IO->catfile("t","data","bovin_small_intact.xml"));
my $g = $io->next_network();

@nodes = $g->nodes;
ok scalar @nodes, 23;

foreach my $node (@nodes) {
	my @seqs = $node->proteins;
	ok $seqs[0]->display_id;
}

# ($ap, $bc, $br) = $g->biconnectivity;

@nodes = $g->articulation_points;
ok scalar @nodes, 4; # OK, inspected in Cytoscape

my @eids = qw(Q29462 P16106 Q27954 P53619);
foreach my $node (@nodes) {
	my @seqs = $node->proteins;
	ok my $id = $seqs[0]->display_id;
	ok grep /$id/, @eids;
}
#
# additional articulation_points tests
# arath_small-02.xml is PSI MI version 1.0
#
ok $io = Bio::Network::IO->new
  (-format => 'psi10',
	-file   => Bio::Root::IO->catfile("t", "data", "arath_small-02.xml"));
ok $g1 = $io->next_network();
ok $g1->nodes, 73;
ok $g1->interactions, 516;
@nodes = $g1->articulation_points;
ok scalar @nodes, 8;

for my $node (@nodes) {
	for my $prot ($node->proteins) {
		ok $prot->display_id;
	}
}

__END__
