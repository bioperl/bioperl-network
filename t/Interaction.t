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
	$NUMTESTS = 17;
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
require Bio::Network::Interaction;
require Bio::Network::Node;
require Bio::Seq;
require Bio::Annotation::Collection;
require Bio::Annotation::OntologyTerm;

my $verbose = 0;
$verbose = 1 if $DEBUG;

ok 1;

my $g = new Bio::Network::ProteinNet;

my $seq1 = Bio::Seq->new(-seq => "aaaaaaa");
my $seq2 = Bio::Seq->new(-seq => "ttttttt");
my $seq3 = Bio::Seq->new(-seq => "ccccccc");

my $node1 = Bio::Network::Node->new(-protein => $seq1);
my $node2 = Bio::Network::Node->new(-protein => [($seq2,$seq3)]);

my $interx = Bio::Network::Interaction->new(-weight => 2,
														-id => "A");
$g->add_interaction(-nodes => [($node1,$node2)],
						  -interaction => $interx);

$interx = Bio::Network::Interaction->new(-weight => 3,
														-id => "B");
$g->add_interaction(-nodes => [($node1,$node2)],
						  -interaction => $interx);

$interx = $g->get_interaction_by_id("A");

ok $interx->primary_id, "A";
ok $interx->object_id, "A";
ok $interx->weight, 2;
my @nodes = $interx->nodes;
ok $#nodes, 1;
my @proteins = $nodes[0]->proteins;
ok $proteins[0]->seq, "aaaaaaa";
@proteins = $nodes[1]->proteins;
ok $proteins[0]->seq, "ttttttt";

my $nodes = $interx->nodes;
ok $nodes, 2;
#
# set values
#
$interx->primary_id("B");
ok $interx->primary_id, "B";
$interx->weight(7);
ok $interx->weight, 7;
#
# check that Bio::Seq objects are automatically converted to Nodes
#
$interx = Bio::Network::Interaction->new(-weight => 2,
													  -id => "C");
$g->add_interaction(-nodes => [($seq1,$seq2)],
						  -interaction => $interx);

$interx = $g->get_interaction_by_id("C");
ok $interx->primary_id, "C";
#
# add and remove Annotations
#
my $comment = Bio::Annotation::Comment->new;
$comment->text("Reliable");
my $coll = new Bio::Annotation::Collection;
$coll->add_Annotation('comment',$comment);
ok $interx->annotation($coll);
my @anns = $coll->get_Annotations('comment');
ok scalar @anns, 1;
ok $anns[0]->as_text, "Comment: Reliable";
my @keys = $coll->get_all_annotation_keys;
ok $keys[0],'comment';
$coll->remove_Annotations('comment');
@anns = $coll->get_Annotations('comment');
ok scalar @anns, 0;

my $term = Bio::Annotation::OntologyTerm->new
(-term => "",
 -name => "N-acetylgalactosaminyltransferase",
 -label => "test",
 -identifier => "000045",
 -definition => "Catalysis of galactossaminylation",
 -ontology => "GO",
 -tagname => "cellular component");
$coll->add_Annotation($term);
ok $interx->annotation($coll);


__END__
