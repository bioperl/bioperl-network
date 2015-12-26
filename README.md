bioperl-network README

A BioPerl package to read protein-protein interaction data and convert it to networks of BioPerl objects.

## Installation

See the accompanying INSTALL file for details on installing
bioperl-network.


## PSI Formats

Different databases offer different variants of the PSI 2.5 format.
Some of these files cannot be parsed by this package. Please see Usage Notes.

## Overview

A ProteinNet is a representation of a protein-protein interaction network.
Its functionality derives from the Graph module of Perl and from BioPerl.
These sorts of networks, or graphs, can be modeled as nodes, or
vertices, connected by edges.

A node is one or more BioPerl sequence objects, a Bio::Seq or 
Bio::Seq::RichSeq object. Since a node can contain more than one
Sequence object it can represent protein complexes as well as proteins.
Essentially the node can be any Bioperl object that implements the
Bio::AnnotatableI and Bio::IdentifiableI interfaces. This is relevant since the identities of nodes are determined by their identifiers.

The bioperl-network modules use Perl's Graph::Undirected 
module and inherit its formal model as well. An edge corresponds to a 
pair of nodes, and there is only one edge per pair. An interaction is an 
attribute of an edge, and there can be 1 or more interactions per edge.
An interaction can be thought of as one experiment or one experimental 
observation. 

The formats that can be parsed are DIP (tab-delimited) and PSI MI
(XML), either version 1 or version 2.5. Capabilities include the
ability to merge networks, select nodes and interactions by
identifier, add and delete components (nodes, interactions, and
edges), count all components of a certain type, get all components of
a certain type, and get subgraphs. Then you have all the functionality
of Perl's Graph in addition such as traversal using different
algorithms, getting interior and exterior nodes, and getting all connected subgraphs. Graph is quite rich in functionality, this list is only a small subset of available methods, see the documentation for Graph for more detail (https://metacpan.org/pod/Graph).

For more detailed documentation also see the
https://metacpan.org/pod/Bio::Network::ProteinNet module.


## Status

This package should be considered a preliminary piece of
work. Although the code is tested and stable it lacks functionality. Not
all fields in the PSI MI standard are parsed into a network, for example.
The BioPAX format is not parsed, arguably as important a format as
PSI MI. In addition useful functions such as searching by sequence or 
ontology term aren't yet implemented.

## History

Modules similar to these were first released as part of the core BioPerl package
and were called Bio::Graph*. Bio::Graph was copied to a separate package,
bioperl-network, and renamed Bio::Network. All of the modules were
revised and a new module, Interaction.pm, was added. The
functionality of the PSI MI 1.0 parser was enhanced and a version
2.5 parser was added.

Graph manipulation in the predecessor Bio::Graph was based on the 
Bio::Graph::SimpleGraph module by Nat Goodman. The first release as a
separate package, bioperl-network, replaced SimpleGraph with the Perl
Graph package. Other API changes were also made, partly to keep
nomenclature consistent with BioPerl, partly to use the terms used by
the public protein interaction databases, and partly to accommodate the
differences between Graph and Bio::Graph::SimpleGraph.

The advantages to using Graph are that Bioperl developers are not
responsible for maintaining the code that actually handles graph
manipulation and there is more functionality in Graph than in SimpleGraph.
You must install version .86 of Graph, or greater.

## Usage Notes

### HPRD

Individual PSI XML files from HPRD can't be parsed as is because the fullName of the organism of an interacting protein is not specific. HPRD uses values like 'Mammalia' rather than the required species names, thus Bio::Species objects can't be constructed. Although I haven't performed an accurate count a simple grep suggests that there are thousands of interacting proteins labelled 'Mammalia'. Since HPRD says that it is concerned exclusively the human proteome it may that one can globally replace 'Mammalia' with 'Homo sapiens'. On the other hand it may be that including an interaction in HPRD is allowed when only one of the interacting pair is human, the definitive test could be performed using the identifiers (BIO 18:16, 31 December 2005 (EST)).

Another thing to notice about HPRD's individual "PSI-MI" files is that they begin with various blocks like protein and interaction and the PSI entrySet section starts somewhere in the middle of the file. BIO 13:33, 23 January 2006 (EST).

References

Mishra GR, Suresh M, Kumaran K, Kannabiran N, Suresh S, Bala P, Shivakumar K, Anuradha N, Reddy R, Raghavan TM, Menon S, Hanumanthu G, Gupta M, Upendran S, Gupta S, Mahesh M, Jacob B, Mathew P, Chatterjee P, Arun KS, Sharma S, Chandrika KN, Deshpande N, Palvankar K, Raghavnath R, Krishnakanth R, Karathia H, Rekha B, Nayak R, Vishnupriya G, Kumar HG, Nagini M, Kumar GS, Jose R, Deepthi P, Mohan SS, Gandhi TK, Harsha HC, Deshpande KS, Sarker M, Prasad TS, and Pandey A. Human protein reference database--2006 update. Nucleic Acids Res. 2006 Jan 1;34(Database issue):D411-4. DOI:10.1093/nar/gkj141 | PubMed ID:16381900 

Peri S, Navarro JD, Kristiansen TZ, Amanchy R, Surendranath V, Muthusamy B, Gandhi TK, Chandrika KN, Deshpande N, Suresh S, Rashmi BP, Shanker K, Padma N, Niranjan V, Harsha HC, Talreja N, Vrushabendra BM, Ramya MA, Yatish AJ, Joy M, Shivashankar HN, Kavitha MP, Menezes M, Choudhury DR, Ghosh N, Saravana R, Chandran S, Mohan S, Jonnalagadda CK, Prasad CK, Kumar-Sinha C, Deshpande KS, and Pandey A. Human protein reference database as a discovery resource for proteomics. Nucleic Acids Res. 2004 Jan 1;32(Database issue):D497-501. DOI:10.1093/nar/gkh070 | PubMed ID:14681466

### IntAct

PSI XML from IntAct has occasional errors, the fullName of the organism of some interacting proteins is absent when the shortLabel of the organism is 'in vitro', these are usually short peptides (fullName is used as a source of species information, thus Bio::Species objects can't be constructed). In one file I examined there were only a few proteins like this, they could be corrected by hand (BIO 18:16, 31 December 2005 (EST)).

### MINT

PSI XML from MINT has occasional errors, the fullName of the organism of some interacting proteins is absent. BIO 13:46, 2 October 2006 (EDT)

Hermjakob H, Montecchi-Palazzi L, Bader G, Wojcik J, Salwinski L, Ceol A, Moore S, Orchard S, Sarkans U, von Mering C, Roechert B, Poux S, Jung E, Mersch H, Kersey P, Lappe M, Li Y, Zeng R, Rana D, Nikolski M, Husi H, Brun C, Shanker K, Grant SG, Sander C, Bork P, Zhu W, Pandey A, Brazma A, Jacq B, Vidal M, Sherman D, Legrain P, Cesareni G, Xenarios I, Eisenberg D, Steipe B, Hogue C, and Apweiler R. The HUPO PSI's molecular interaction format--a community standard for the representation of protein interaction data. Nat Biotechnol. 2004 Feb;22(2):177-83. DOI:10.1038/nbt926 | PubMed ID:14755292 

