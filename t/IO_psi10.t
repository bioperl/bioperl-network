# This is -*-Perl-*- code#
# Bioperl Test Harness Script for Modules#
# $Id$

use strict;

BEGIN {
	use Bio::Root::Test;
	test_begin(-tests => 21,
			   -requires_module => 'Graph',
			   -requires_module => 'XML::Twig');

	use_ok('Bio::Network::IO');
}

my $verbose = test_debug();

#
# PSI XML from DIP
#
ok my $io = Bio::Network::IO->new
  (-format => 'psi10',
	-file   => test_input_file("psi_xml.dat"));
ok my $g1 = $io->next_network();
ok $g1->edge_count == 3;
ok $g1->node_count == 4;
ok $g1->is_connected == 1;
my $n = $g1->get_nodes_by_id('O24853');
my @proteins = $n->proteins;
ok $proteins[0]->species->binomial('FULL') eq "Helicobacter pylori 26695";
ok $proteins[0]->primary_seq->desc eq "hypothetical HP0001";
my @rts = $g1->articulation_points;
ok scalar @rts == 1; # correct, by inspection in Cytoscape
@proteins = $rts[0]->proteins;
my $seq = $proteins[0];
ok $seq->desc eq "hypothetical HP0001"; # correct, by inspection in Cytoscape

#
# PSI XML from IntAct
#
ok $io = Bio::Network::IO->new
  (-format => 'psi10',
	-file   => test_input_file("sv40_small.xml"));
ok $g1 = $io->next_network();
ok $g1->edge_count == 3;
ok $g1->node_count == 5;
ok $g1->is_connected eq "";

$n = $g1->get_nodes_by_id("P03070");
@proteins = $n->proteins;
ok $proteins[0]->species->binomial('FULL') eq "Simian virus 40";
ok $proteins[0]->primary_seq->desc eq "Large T antigen";

my @components = $g1->connected_components;
ok scalar @components == 2;

# there was an intermittent bug in articulation_points() here
# but not in the invocation above, this appears to be fixed
# in Graph v. .86
@rts = $g1->articulation_points;
ok scalar @rts == 1;
@proteins = $rts[0]->proteins;
$seq = $proteins[0];
ok $seq->desc eq "Erythropoietin receptor precursor";

#
# GO terms
#
$n = $g1->get_nodes_by_id("EBI-474016");
@proteins = $n->proteins;

#
# PSI XML from HPRD
#
ok $io = Bio::Network::IO->new
  (-format => 'psi10',
	-file   => test_input_file("00001.xml"));
# ok $g1 = $io->next_network(); 
# The individual files from HPRD are not standard PSI, problems parsing them

__END__

