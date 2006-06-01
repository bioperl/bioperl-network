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
	$NUMTESTS = 30;
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
require Bio::Network::Node;
require Bio::Seq;

my $verbose = 0;
$verbose = 1 if $DEBUG;

ok 1;

my $seq1 = Bio::Seq->new(-seq => "aaaaaaa",-display_id => 1);
my $seq2 = Bio::Seq->new(-seq => "ttttttt",-display_id => 2);
my $seq3 = Bio::Seq->new(-seq => "ggggggg",-display_id => 3);

#
# 1 protein
#
my $node = Bio::Network::Node->new(-protein => $seq1);
ok $node->is_complex, 0;
my $count = $node->proteins;
ok $count, 1;

my @proteins = $node->proteins;
ok $proteins[0]->seq, "aaaaaaa";
ok $proteins[0]->display_id, 1;
ok $node->subunit_number($proteins[0]), undef;
$node->subunit_number($proteins[0],52);
ok $node->subunit_number($proteins[0]), 52;

#
# 1 or more proteins, but no subunit composition
#
$node = Bio::Network::Node->new(-protein => [($seq1,$seq2,$seq3)]);
ok $node->is_complex, 1;
@proteins = $node->proteins;
my $x = 0;
my @seqs = qw(aaaaaaa ggggggg ttttttt);
for my $protein (@proteins) {
	ok $protein->seq, $seqs[$x++];
	ok $node->subunit_number($protein), undef;
}
$count = $node->proteins;
ok $count, 3;

$node = Bio::Network::Node->new(-protein => [($seq1)]);
ok $node->is_complex, 0;

#
# 1 or more proteins, specifying subunit composition
#
$node = Bio::Network::Node->new(-protein => [ [($seq1, 2) ],
														  [ ($seq2, 3) ],
														  [ ($seq3, 1)] ]);
ok $node->is_complex, 1;
@proteins = $node->proteins;
$x = 0;
@seqs = qw(aaaaaaa ggggggg ttttttt);
my @nums = (2,1,3);
for my $protein (@proteins) {
	ok $protein->seq, $seqs[$x];
	ok $node->subunit_number($protein), $nums[$x++];
}
$count = $node->proteins;
ok $count, 3;

$node = Bio::Network::Node->new(-protein => [ [($seq3, 1)] ]);
ok $node->is_complex, 0;
ok $node->proteins, 1;

$node = Bio::Network::Node->new(-protein => [ [($seq3, 1)],
														  [($seq2, 1)] ] );
ok $node->is_complex, 1;
ok $node->proteins, 2;
$node->is_complex(0);
ok $node->is_complex, 0;

$node->subunit_number($seq2,2);
ok $node->subunit_number($seq2), 2;

__END__

