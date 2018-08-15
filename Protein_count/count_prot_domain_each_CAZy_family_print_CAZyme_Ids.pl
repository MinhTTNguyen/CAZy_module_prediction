=pod
July 23rd 2015
This script is to print out IDs of CAZymes for each family
Input:CAZyme list
Output: family	protcount	protids
=cut

#! C:\Perl64\bin -w
use strict;

print "\nInput file containing list of CAZymes: ";
my $filein=<STDIN>;
chomp($filein);

my $fileout=substr($filein,0,-4);
$fileout=$fileout."_protids_each_family.txt";

open(In,"<$filein") || die "Cannot open file $filein";
open(Out,">$fileout") || die "Cannot open file $fileout";
print Out "#Family_group\tFamily_number\tFamily\tProtein_count\tProtein_IDs\n";
my %hash_family_protids;
while (<In>)
{
	chomp($_);
	unless ($_=~/^#/)
	{
		my @columns=split(/\t/,$_);
		my $protid=$columns[0];
		my $all_families=$columns[1];
		my @families=split(/ - /,$all_families);
		my %hash_families;
		foreach my $family (@families){$hash_families{$family}++;}
		my @unique_families=keys(%hash_families);
		foreach my $family (@unique_families)
		{
			if ($hash_family_protids{$family}){$hash_family_protids{$family}=$hash_family_protids{$family}.";".$protid;}
			else{$hash_family_protids{$family}=$protid;}
		}
	}
}
while (my ($k, $v)=each (%hash_family_protids))
{
	my @ids=split(/\;/,$v);
	my %hash_ids;
	foreach my $id (@ids){$hash_ids{$id}++;}
	my @unique_ids=keys(%hash_ids);
	my $protcount=scalar(@unique_ids);
	my $all_unique_ids=join(";",@unique_ids);
	
	my $family_number=$k;
	$family_number=~s/\D*//g; #\D: any non-digit character
	
	my $family_group=$k;
	$family_group=~s/\d*$//;
	print Out "$family_group\t$family_number\t$k\t$protcount\t$all_unique_ids\n";
}
close(In);
close(Out);
