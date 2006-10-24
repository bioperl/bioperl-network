# --Makefile.PL for bioperl-network distribution-------
# ---------------------------------------------------------
# $Id$
# ---------------------------------------------------------
#
# Basically this is a standard Makefile.PL with a hash of
# needed packages which are tested at the start
#
# If you want help with this file get in touch with the 
# developers by sending a message to bioperl-l@bioperl.org.

# All bioperl-network dependencies on external modules are defined here
%packages = (
 'Graph' => '0.80/Graph data structures and algorithms/graph construction and analysis/Bio::Network::ProteinNet',
 'XML::Twig' => '3.22/Read and write XML/parsing PSI XML/Bio::Graph::IO::psi',
 'Bio::Root::Version'       => '0.0/Bioperl//',
);

sub check_package {
	my ($name,$str) = @_;
	my ($ver,$desc,$expl,$module) = split( /\// , $str);
	if ( !eval "require($name)") {
		if ($name eq 'Bio::Root::Version') {
		  print "Bioperl-network absolutely needs Bioperl to work - It makes no sense without it\n";
		  exit(0);
		}
		print "External Module $name $ver, $desc,\nis not installed on this computer.\n" .
		      "$module in bioperl-network needs it for $expl\n\n";
		return 1;
	}
	return 0;
}

#
# Generate sub testing package system
#

# make mini test targets for playing around with in testing...

opendir(DIR,"t") || die "No test directory.";
@files = readdir(DIR);
shift @files;
shift @files;
foreach my $file (@files) {
	$file =~ /(\w+)\.t/ || next;
	$file = $1;
	$line = "test_$file :: pure_all\n\tPERL_DL_NONLAZY=1 \$(FULLPERL) -I\$(INST_ARCHLIB) -I\$(INST_LIB) -I\$(PERL_ARCHLIB) -I\$(PERL_LIB) -e \'use Test::Harness qw(&runtests \$\$verbose); \$\$verbose=\$(TEST_VERBOSE); runtests \@ARGV;\' t/$file.t\n";
	push(@tline,$line);
	push(@targets,$file);
	$tset  .= "$file \\\n";
}

$tline = join('',@tline);
$tline = "show_tests :\n\t\@echo \'type make test_<subtest> to run\'\n\t\@echo '$tset'\n$tline\n";

print STDERR "Generated sub tests. Do \"make show_tests\" to see available subtests\n";

sub MY::postamble { $tline; }

# Let the code begin...

require 5.005;
use ExtUtils::MakeMaker ;

$do_autoload_finesse = 0;
$NAME     = 'Bio';
$DISTNAME = "bioperl-network";
$VERSION  = "0.1";

$error = 0;
print "\n";
for $name ( keys %packages ) {
	if ( &check_package($name,$packages{$name}) == 1 ) {
		$error = 1;
	}
}

if ( $error == 1 ) {
	print <<QQ_ERROR_QQ;

Warning:

   There are some Perl modules, listed above, which bioperl-network uses.

   The installation of these external packages is very simple. You
   can read more about Bioperl external dependencies at

   http://bioperl.open-bio.org/wiki/Main_Page
   
QQ_ERROR_QQ
}

# generate hash for prerequisites
# # for use in WriteMakefile
my %prereq;
while (my ($key, $value) = each %packages) {
  my ($version,$desc,$expl,$module) = split( /\// , $value);
  $prereq{$key} = $version;
}

WriteMakefile(
				  NAME	=> $NAME,
				  DISTNAME    => $DISTNAME,
				  VERSION     => $VERSION,
				  'dist'      => {  COMPRESS     => 'gzip -9f',
										  SUFFIX       => '.gz', 
										  DIST_DEFAULT => 'all tardist',
									  },
				  ($] ge '5.005')  ? (
				  'AUTHOR'   => 'Bioperl Team (bioperl-l@bioperl.org)',
				  'ABSTRACT' => 'bioperl-network - package for biological networks',
											) : (),
				  'realclean' => {  FILES        => join(' ',@BACKUP_FILES) },
				  DIR         => [  ], # directories with other Makefile.PL's in them
				  PREREQ_PM   => \%prereq,
				 );
