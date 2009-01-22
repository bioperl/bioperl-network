# This is -*-Perl-*- code#
# Bioperl Test Harness Script for Modules#
# $Id$

use vars qw($NUMTESTS $DEBUG $ERROR);
use strict;
$DEBUG = $ENV{'BIOPERLDEBUG'} || 0;

BEGIN {
	use lib ".";
	use Bio::Root::Test;
	test_begin(-tests => 10,
				  -requires_module => 'Graph',
				  -requires_module => 'XML::Twig' );

	use_ok('Bio::Network::IO');
}

my $verbose = 0;
$verbose = 1 if $DEBUG;

ok 1;

#
# PSI XML from IntAct
#
ok my $io = Bio::Network::IO->new
  (-format  => 'psi25',
	-file    => Bio::Root::IO->catfile("t", "data", "human_small-01.xml"),
   -verbose => $verbose );
ok my $g1 = $io->next_network(); 
ok $g1->node_count == 646;
# remember that interactions are only formed of pairs of nodes 
ok $g1->interactions == 439;
#
# PSI XML from MINT
#
ok $io = Bio::Network::IO->new
  (-format => 'psi25',
	-file   => Bio::Root::IO->catfile("t", "data", "Viruses.psi25.xml"),
   -verbose => $verbose );
ok $g1 = $io->next_network(); 
ok $g1->node_count == 521;
ok $g1->interactions == 994;


__END__
