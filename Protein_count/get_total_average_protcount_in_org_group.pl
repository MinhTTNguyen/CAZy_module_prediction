# October 6th 2015
# This script is to get the average protein out number of each CAZy family from a group of organisms

#! /usr/perl/bin -w
use strict;

print "\nInput list of all CAZy families (including path): ";
my $filein_all_cazy=<STDIN>;
chomp($filein_all_cazy);

print "\nInput common path of input and output files: ";
my $path=<STDIN>;
chomp($path);

print "\nInput folder containing protein count files: ";
my $folderin=<STDIN>;
chomp($folderin);

print "\nName of output file: ";
my $fileout=<STDIN>;
chomp($fileout);


opendir(DIR,"$path/$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
my %hash_fami_protcount;
my %hash_fami_total_protcount;
my $total_species=0;
foreach my $filein (@files)
{
	unless (($filein eq ".") ||  ($filein eq ".."))
	{
		open(In,"<$path/$folderin/$filein") || die "Cannot open file $filein";
		$total_species++;
		while (<In>)
		{
			unless ($_=~/^\#/)
			{
				chomp($_);
				my @columns=split(/\t/,$_);
				my $family=$columns[0];
				my $protcount=$columns[1];
				$hash_fami_protcount{$family}=$hash_fami_protcount{$family}+$protcount;
				$hash_fami_total_protcount{$family}=$hash_fami_total_protcount{$family}+$protcount;
			}
		}
		close(In);
	}
}
while (my ($k, $v)=each (%hash_fami_protcount)){$hash_fami_protcount{$k}=$v/$total_species}
closedir(DIR);

open(All_CAZy,"<$filein_all_cazy") || die "Cannot open file $filein_all_cazy";
open(Out,">$path/$fileout") || die "Cannot open file $fileout";
print Out "#CAZy_family\tAverage_protein_count\tTotal_protein_count\n";
while (<All_CAZy>)
{
	$_=~s/\s*//g;
	my $total_protein_count=$hash_fami_total_protcount{$_};
	my $avg_protein_count=$hash_fami_protcount{$_};
	unless ($total_protein_count){$total_protein_count=0;}
	unless($avg_protein_count){$avg_protein_count=0;}
	print Out "$_\t$avg_protein_count\t$total_protein_count\n";
}
close(All_CAZy);
close(Out);