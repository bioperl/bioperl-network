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
	$NUMTESTS = 19;
	plan tests => $NUMTESTS;
	eval { require Graph; };
	if ( $@ ) {
		warn("Graph required for graph creation and analysis, skipping tests");
		$ERROR = 1;
	}
	eval { require XML::Twig; };
	if ($@) {
		warn "XML::Twig needed for XML format parsing, skipping tests";
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

ok 1;

#
# PSI XML from DIP
#
ok my $io = Bio::Network::IO->new
  (-format => 'psi',
	-file   => Bio::Root::IO->catfile("t", "data", "psi_xml.dat"));
ok my $g1 = $io->next_network();
ok $g1->edge_count, 3;
ok $g1->node_count, 4;
ok $g1->is_connected,1;
my $n = $g1->get_nodes_by_id('O24853');
my @proteins = $n->proteins;
ok $proteins[0]->species->binomial('FULL'),"Helicobacter pylori 26695";
ok $proteins[0]->primary_seq->desc,"hypothetical HP0001";
my @rts = $g1->articulation_points;
ok scalar @rts,1; # correct, by inspection in Cytoscape
@proteins = $rts[0]->proteins;
my $seq = $proteins[0];
ok $seq->desc,"hypothetical HP0001"; # correct, by inspection in Cytoscape

#
# PSI XML from IntAct
#
ok $io = Bio::Network::IO->new
  (-format => 'psi',
	-file   => Bio::Root::IO->catfile("t", "data", "sv40_small.xml"));
ok $g1 = $io->next_network();
ok $g1->edge_count, 3;
ok $g1->node_count, 5;
ok $g1->is_connected, "";

$n = $g1->get_nodes_by_id("P03070");
@proteins = $n->proteins;
ok $proteins[0]->species->binomial('FULL'),"Simian virus 40";
ok $proteins[0]->primary_seq->desc,"Large T antigen";

my @components = $g1->connected_components;
ok scalar @components, 2;

# seems there's an intermittent bug in articulation_points() here
# but not in the invocation above
# @rts = $g1->articulation_points;
# ok scalar @rts, 1; # OK, inspected in Cytoscape
# @proteins = $rts[0]->proteins;
# $seq = $proteins[0];
# ok $seq->desc,"Erythropoietin receptor precursor"; # OK, inspected in Cytoscape

#
# GO terms
#
$n = $g1->get_nodes_by_id("EBI-474016");
@proteins = $n->proteins;

#
# PSI XML from HPRD
#
ok $io = Bio::Network::IO->new
  (-format => 'psi',
	-file   => Bio::Root::IO->catfile("t", "data", "00001.xml"));
# ok $g1 = $io->next_network(); 
# The individual files from HPRD are not standard PSI, problems parsing them

__END__

