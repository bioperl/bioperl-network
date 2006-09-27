# This is -*-Perl-*- code#
# Bioperl Test Harness Script for Modules#
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
	$NUMTESTS  = 16;
	plan tests => $NUMTESTS;
	eval { require Graph; };
	if ( $@ ) {
		warn("Perl's Graph required by the bioperl-network package, skipping tests");
		$ERROR = 1;
	}
}

END {
	foreach ( $Test::ntest..$NUMTESTS) {
		skip("Missing dependencies. Skipping tests",1);
	}
}
exit 0 if $ERROR == 1;

require Graph::Undirected;
require Graph::Traversal::DFS;
require Bio::Seq;

#
# The purpose of these tests is to check to see if bugs have been
# fixed in Perl's Graph, particularly if refvertexed == 1
#
my $g = Graph::Undirected->new(refvertexed => 1);

ok 1;

my $seq1 = Bio::Seq->new(-seq => "aaaaaaa");
my $seq2 = Bio::Seq->new(-seq => "ttttttt");
my $seq3 = Bio::Seq->new(-seq => "ccccccc");
my $seq4 = Bio::Seq->new(-seq => "ggggggg");

$g->add_vertices($seq1,$seq2,$seq3,$seq4);
$g->add_edges([$seq1,$seq2],[$seq3,$seq4],[$seq3,$seq2]);

my @vs = $g->vertices;
ok $vs[0]->seq;

my $c = $g->complete;
@vs = $c->vertices;
ok $vs[0]->seq;

my $comp = $g->complement;
@vs = $comp->vertices;
ok $vs[0]->seq;

@vs = $g->interior_vertices;
ok $vs[0]->seq;

my $apsp = $g->APSP_Floyd_Warshall;
@vs = $apsp->path_vertices($seq1,$seq4);
ok $vs[0]->seq;

my $seq = $g->random_vertex;
ok $seq->seq;

my $t = Graph::Traversal::DFS->new($g);
$t->dfs;
@vs = $t->seen;
for my $seq (@vs) {
	ok $seq->seq;
}

# Still an intermittent bug
# @vs = $g->articulation_points; 
# ok $vs[0]->seq; # not OK in Graph v. .80
# ok scalar @vs, 2;

my @cc = $g->connected_components;
for my $ref (@cc) {
	for my $seq (@$ref) {
		ok $seq->seq;
	}
}

my @bs = $g->bridges;
ok $bs[0][0]->seq;

my $cg = $g->connected_graph;
@vs = $cg->vertices;
# ok $vs[0]->seq; incorrect usage

my @spd = $g->SP_Dijkstra($seq1,$seq4);

my @spbf = $g->SP_Bellman_Ford($seq1,$seq4);

__END__
