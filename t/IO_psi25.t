# This is -*-Perl-*- code#
# Bioperl Test Harness Script for Modules#
# $Id$

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
	$NUMTESTS = 5;
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
# PSI XML from IntAct
#
ok my $io = Bio::Network::IO->new
  (-format => 'psi25',
	-file   => Bio::Root::IO->catfile("t", "data", "human_small-01.xml"));
ok my $g1 = $io->next_network(); 
ok $g1->node_count, 646;
# remember that interactions are only formed of pairs of nodes 
ok $g1->interactions, 439;


__END__
