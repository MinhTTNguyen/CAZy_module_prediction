# April 13th 2017
# Print out protein count numbers for each CAZy family from each species in the analysis of CAZyme comparison between AF, ANF and RB

#! /usr/bin/perl -w
use strict;


my $folderin="/home/mnguyen/Research/Bacillus/CAZymes/Bacillus_domain_count_nosubfamily";
my $fileout="/home/mnguyen/Research/Bacillus/CAZymes/Bacillus_domain_count_nosubfamily.txt";

my %hash_cazy_families;
my @org_list;

&Get_protcount($folderin,"JGI");

open(Out,">$fileout") || die "Cannot open file $fileout";
print Out "Family";
foreach (@org_list){print Out "\t$_";}
print Out "\n";

while (my ($k_family,$v_protcount)=each (%hash_cazy_families))
{
	print Out "$k_family";
	my %hash_org_procount;
	my @org_protcounts=split(/\t/,$v_protcount);
	foreach (@org_protcounts)
	{
		if ($_=~/(.+)\:(.+)/)
		{
			my $org=$1;
			my $count=$2;
			$hash_org_procount{$org}=$count;
		}
		else{print "\nError (line".__LINE__."): organism:protcount is not as described!: -$_-\n";exit;}
	}
	foreach my $org (@org_list)
	{
		unless ($hash_org_procount{$org}){$hash_org_procount{$org}=0;}
		print Out "\t$hash_org_procount{$org}";
	}
	print Out "\n";
	%hash_org_procount=();#empty hash
}
close(Out);


###################################################################################################################################################################
sub Get_protcount
{
	my $folderin=$_[0];
	my $group=$_[1];
	
	opendir(DIR, $folderin) || die "Cannot open folder $folderin";
	my @files=readdir(DIR);
	foreach my $filein (@files)
	{
		if (($filein ne ".") and ($filein ne ".."))
		{
			my $species=substr($filein,0,-4);
			$species=$group."_".$species;
			push(@org_list,$species);
		
			open(IN,"<$folderin/$filein") || die "Cannot open file $filein";
			while (<IN>)
			{
				#$_=~s/^\s*//;$_=~s/\s*$//;
				chomp($_);
				if ($_!~/^\#/)
				{
					my @cols=split(/\t/,$_);
					my $family=$cols[0];
					my $protcount=$cols[1];
					if ($hash_cazy_families{$family}){$hash_cazy_families{$family}=$hash_cazy_families{$family}."\t".$species.":".$protcount;}
					else{$hash_cazy_families{$family}=$species.":".$protcount;}
				}
			}
			close(IN);
		}
	}
	closedir(DIR);
}
###################################################################################################################################################################



