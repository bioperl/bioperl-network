#!/usr/bin/perl -w

# This is a Module::Build script for bioperl-network installation.
# See http://search.cpan.org/~kwilliams/Module-Build/lib/Module/Build.pm

use strict;
use warnings;
use Module::Build;

# Set up the Bio::Root::Build object
my $build = Module::Build->new(
    module_name         => 'Bio',
    dist_name           => 'BioPerl-network',
    dist_version        => '1.006000',
    dist_author         => 'BioPerl Team <bioperl-l@bioperl.org>',
    dist_abstract       => 'BioPerl-network - package for biological networks',
    license             => 'perl',
    requires            => {'perl'                => 5.006001,
                            'Bio::Root::Version'  => 1.006000, # checked above
                            'Graph'               => 0.86 },
    recommends          => {
                            'XML::Twig' => 3.22, # parsing PSI XML/Bio::Graph::IO::psi
                           },
    dynamic_config      => 1,
    create_makefile_pl  => 'passthrough'
    
    #pm_files           => {} # modules in Bio are treated as if they were in lib and auto-installed
    #script_files       => [] # scripts in scripts directory are installed on-demand
);

# Create the build script and exit
$build->create_build_script;

exit;
