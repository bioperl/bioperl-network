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
	$NUMTESTS = 16;
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
	unlink "t/data/out.tab" if -e "t/data/out.tab";
}

exit 0 if $ERROR ==  1;

require Bio::Network::IO;

my $verbose = 0;
$verbose = 1 if $DEBUG;

ok 1;

#
# read new DIP format
#
my $io = Bio::Network::IO->new(
    -format => 'dip_tab',
    -file   => Bio::Root::IO->catfile("t","data","tab4part.tab"));
my $g1 = $io->next_network();
ok $g1->edges,5;
ok $g1->vertices,7;
#
# read old DIP format
#
$io = Bio::Network::IO->new(
  -format => 'dip_tab',
  -file   => Bio::Root::IO->catfile("t","data","tab1part.tab"),
  -threshold => 0.6);
ok(defined $io);
ok $g1 = $io->next_network();
ok my $node = $g1->get_nodes_by_id('PIR:A64696');
my @proteins = $node->proteins;
ok $proteins[0]->accession_number, 'PIR:A64696';
my %ids = $g1->get_ids_by_node($node);
my $x = 0;
my @ids = qw(A64696 2314583 3053N);
for my $k (keys %ids) {
	ok $ids{$k},$ids[$x++];
}
#
# test write to filehandle...
#
my $out =  Bio::Network::IO->new(
  -format => 'dip_tab',
  -file   => ">". Bio::Root::IO->catfile("t","data","out.tab"));
ok(defined $out);
ok $out->write_network($g1);
#
# can we round trip, is the output the same as original format?
#
my $io2 = Bio::Network::IO->new(
  -format   => 'dip_tab',
  -file     => Bio::Root::IO->catfile("t","data","out.tab"));
ok defined $io2;
ok	my $g2 = $io2->next_network();
ok $node = $g2->get_nodes_by_id('PIR:A64696');
@proteins = $node->proteins;
ok $proteins[0]->accession_number, 'PIR:A64696';

__END__

