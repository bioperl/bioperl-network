# $Id$
#
# BioPerl module for Bio::Network::IO::psi::intact
#
# You may distribute this module under the same terms as perl itself
# POD documentation - main docs before the code

=head1 NAME

Bio::Network::IO::psi::intact - module to handle variations
in PSI MI format from the IntAct database

=head1 SYNOPSIS

Do not use this module directly, use Bio::Network::IO. For example:

  my $io = Bio::Network::IO->new(-format => 'psi',
                                 -source => 'intact',
                                 -file   => 'data.xml');

  my $network = $io->next_network;

=head1 DESCRIPTION

There are slight differences between PSI MI files offered by various public 
databases. The Bio::Network::IO::psi* modules have methods for handling
these variations. To load a module like this use the optional "-source" 
argument when creating a new Bio::Network::IO object.

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to one
of the Bioperl mailing lists. Your participation is much appreciated.

  bioperl-l@bioperl.org             - General discussion
  http://bio.perl.org/MailList.html  - About the mailing lists

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track
the bugs and their resolution.  Bug reports can be submitted via the
web:

  http://bugzilla.bioperl.org/

=head1 AUTHORS

Brian Osborne osborne1@optonline.net

=cut

package Bio::Network::IO::psi::intact;
use strict;
use vars qw(@ISA $FAC);
use Bio::Network::IO;
use Bio::Annotation::DBLink;
use Bio::Annotation::Collection;

=head2

 Name     :
 Purpose  : 
 Arguments: 
 Returns  : 
 Usage    :

=cut

sub {

}

1;

__END__
