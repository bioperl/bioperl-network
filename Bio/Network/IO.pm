# $Id$
#
# BioPerl module for Bio::Network::IO
#
# You may distribute this module under the same terms as perl itself
# POD documentation - main docs before the code

=head1  NAME

Bio::Network::IO - Class for reading and writing biological network data.

=head1  SYNOPSIS

This is a modules for reading and writing protein-protein interaction
and creating networks from this data.

  # Read protein interaction data in some format
  my $io = Bio::Network::IO->new(-file => 'bovine.xml',
                                 -format => 'psi_xml' );
  my $network = $io->next_network;

=head1  DESCRIPTION

This class is analagous to the SeqIO and AlignIO classes. To read in a
file of a particular format, file and format are given as key/value
pairs as arguments.  The Bio::Network::IO checks that the appropriate
module is available and loads it.

At present only the DIP tab-delimited format and PSI XML format are 
supported.

=head1 METHODS

The main methods are:

=head2  $net = $io-E<gt>next_network

The next_network method does not imply that multiple networks are
contained in a file, this is to maintain the consistency of nomenclature
with the $seqio-E<gt>next_seq() and $alnio-E<gt>next_aln() methods.

=head2  $io-E<gt>write_network($network)

UNIMPLEMENTED.

=head1 REQUIREMENTS

To read or write from PSI XML you will need the XML::Twig module, 
available from CPAN.

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to one
of the Bioperl mailing lists.

Your participation is much appreciated.

  bioperl-l@bioperl.org                  - General discussion
  http://bioperl.org/MailList.shtml      - About the mailing lists

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track
the bugs and their resolution.  Bug reports can be submitted via the
web:

  http://bugzilla.bioperl.org/

=head1 AUTHORS

Richard Adams richard.adams@ed.ac.uk
Brian Osborne osborne1@optonline.net

=cut

package Bio::Network::IO;
use strict;
use vars qw(@ISA %DBNAMES);
use Bio::Root::IO;

@ISA = qw(Bio::Root::IO);

# these values are used to standardize database names
%DBNAMES = (
				DIP => "DIP",     # found in DIP files
				SWP => "UniProt", # found in DIP files
				PIR => "PIR",     # found in DIP files
				GI  => "GenBank"  # found id DIP files
			  );

=head2  new

 Name       : new
 Usage      : $io = Bio::Network::IO->new(-file => 'myfile.xml', 
                                          -format => 'psi_xml');
 Returns    : A Bio::Network::IO stream initialised to the appropriate format.
 Args       : Named parameters: 
              -file      => $filename
              -format    => format
				  -threshold => a confidence score for the interaction, optional

=cut

sub new {
	my ($caller, @args) = @_;
	my $class = ref($caller) || $caller;
	if ($class =~ /Bio::Network::IO::(\S+)/){
		my $self = $class->SUPER::new(@args);
		$self->_initialize_io(@args);
		return $self;
	} else {
		my %param = @args;
		@param{ map { lc $_ } keys %param } = values %param;
		if (!exists($param{'-format'})) {
			Bio::Root::Root->throw("Must specify a valid format!");
		} 
		my $format = $param{'-format'};
		$format    = "\L$format";	
		return undef unless ($class->_load_format_module($format)); 
		return "Bio::Network::IO::$format"->new(@args);
	}
}

=head2    next_network

 Name       : next_network
 Usage      : $gr = $io->next_network
 Returns    : A Bio::Network::ProteinNet object.
 Args       : None

=cut

sub next_network {
   my ($self, $gr) = @_;
   $self->throw("Sorry, you cannot read from a generic Bio::Network::IO object.");
}

=head2    write_network

 Name       : write_network
 Usage      : $gr = $io->write_network($net).
 Args       : A Bio::Network::ProteinNet object.
 Returns    : None

=cut

sub write_network {
   my ($self, $gr) = @_;
   $self->throw("Sorry, you can't write from a generic Bio::NetworkIO object.");
}


=head2 _load_format_module

 Title   : _load_format_module
 Usage   : *INTERNAL Bio::Network::IO stuff*
 Function: Loads up (like use) a module at run time on demand
 Returns :
 Args    :

=cut

sub _load_format_module {
	my ($self, $format) = @_;
	my $module = "Bio::Network::IO::" . $format;
	my $ok;

	eval {
		$ok = $self->_load_module($module);
	};
	if ( $@ ) {
		print STDERR <<END
$self: $format cannot be found
Exception $@
For more information about the Bio::Network::IO system please see the Bio:Network::IO docs.
END
;
	}
	return $ok;
}

=head2 _initialize_io

 Title   : _initialize_io
 Usage   : *INTERNAL Bio::Network::IO stuff*
 Function: 
 Returns :
 Args    :

=cut

sub _initialize_io {
	my ($self, @args) = @_;
	$self->SUPER::_initialize_io(@args);
	my ($th) = $self->_rearrange( [qw(THRESHOLD)], @args);
	$self->{'_th'} = $th;
	return $self;
}

=head2 _get_standard_name

 Title   : _get_standard_name
 Usage   :
 Function: Returns some standard name for a database, uses global
           %DBNAMES
 Returns :
 Args    :

=cut

sub _get_standard_name {
	my ($self,$name) = @_;
	$DBNAMES{$name};
}

1;
