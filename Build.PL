#!/usr/bin/perl -w

# This is a Module::Build script for bioperl-network installation.
# See http://search.cpan.org/~kwilliams/Module-Build/lib/Module/Build.pm

# Uses a custom subclass of Module::Build called ModuleBuildBioperl that
# doesn't get installed

use strict;
use ModuleBuildBioperl;

# Set up the ModuleBuildBioperl object
my $build = ModuleBuildBioperl->new(
    module_name         => 'Bio',
    dist_name           => 'bioperl-network',
    dist_version        => 1.005002005,
    dist_author         => 'Bioperl Team <bioperl-l@bioperl.org>',
    dist_abstract       => 'bioperl-network - package for biological networks',
    license             => 'artistic',
    requires            => {
                            'perl'                      => '5.6.1',
                            'Bio::Root::Version'        => '1.5.2',
                            'Graph'                     => 0.8
                           },
    recommends          => {
                            'XML::Twig'					=> '3.22/parsing PSI XML/Bio::Graph::IO::psi'
                           },
    dynamic_config      => 1
    
    #pm_files           => {} # modules in Bio are treated as if they were in lib and auto-installed
    #script_files       => [] # scripts in scripts directory are installed on-demand
);

# Create the build script and exit
$build->create_build_script;

exit;
