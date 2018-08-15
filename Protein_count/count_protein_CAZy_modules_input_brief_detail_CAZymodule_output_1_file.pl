=pod
February 2nd 2015
This script is to print out all CAZy modules (e.g. GH10-CBM20, GH10-GH11) detected in the CAZyme annotation
Also, count the number of proteins for each module
Input:
Protein_ID	CAZy_module_prediction (e.g., Cluster0033687: CBM48.hmm (2.50E-06 , 57%) - GH13.hmm (1.20E-23 , 79%))

Modified on February 13th 2015
Input
#Seq_id	CAZy_module	CAZy_module (evalue, HMM coverage)
PIRRH_ORF_16073	PL3	PL3 (5.20E-45 , 65%)

Modified on Feb 16th 2015
Print all modules into 1 file (Previously, 2 output files: sing domain, multiple domains)

Modified on Jul 3rd 2017
for runnning on Unix system
=cut

#! /usr/perl/bin -w
use strict;

=pod
print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput file containing predicted CAZymes: ";
my $filein=<STDIN>;
chomp($filein);
=cut

my $path="/home/mnguyen/Research/Albert/CAZyme/ANF_3Jul2017";
my $filein="Anamu_Corrected_unknown_CAZymes.txt";
my $fileout=substr($filein,0,-4);
my $fileout=$fileout."_module_protcount.txt";

open(In,"<$path/$filein") || die "Cannot open file $filein";
open(Out,">$path/$fileout") || die "Cannot open file $fileout";

my %hash_module_prot_count;
while (<In>)
{
	$_=~s/\s*$//;
	if($_!~/^\#/)
	{
		if ($_=~/^.+\t(.+)\t.+/)#PIRRH_ORF_16073	PL3	PL3 (5.20E-45 , 65%)
		{
			my $CAZy_module=$1;
			$CAZy_module=~s/\s*//g;
			$hash_module_prot_count{$CAZy_module}++;
		}else{print "Error: Line in input file is not as described!\n$_\n";exit;}
	}
}

print Out "#CAZy_module\tProtein_count\n";

while (my ($k, $v)=each (%hash_module_prot_count))
{
	print Out "$k\t$v\n";
}
close(In);
close(Out);
