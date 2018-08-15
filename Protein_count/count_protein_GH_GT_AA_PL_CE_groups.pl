# October 9th 2015
# Count the number of gene from GH, CE, PL, GT, AA groups
# Input: CAZyme list

#! /usr/perl/bin -w
use strict;

=pod
print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput file containing CAZyme list: ";
my $filein=<STDIN>;
chomp($filein);

print "\nInput name of output file: ";
my $fileout=<STDIN>;
chomp($fileout);
=cut

my $path="/home/mnguyen/Research/Albert/CAZyme/ANF_May2017/hmmscan_dbCANcutoff/Known_CAZymes";
my $filein="Orpinomyces_spC1A_known_CAZymes.txt";
my $fileout="Orpinomyces_spC1A_known_CAZymes_group_protcount.txt";
open(In,"<$path/$filein") || die "Cannot open file $filein";
my %hash_group_protcount;
while (<In>)
{
	$_=~s/\s*$//;
	unless ($_=~/^\#/)
	{
		my @columns=split(/\t/,$_);
		my $cazy_module=$columns[1];
		$cazy_module=~s/\s*//g;
		$cazy_module=~s/\d+//g;
		my @domains=split(/-/,$cazy_module);
		my %hash_domain_group;
		foreach my $domain (@domains){$hash_domain_group{$domain}++;}
		my @cazy_groups=keys(%hash_domain_group);
		foreach my $cazy_group (@cazy_groups){$hash_group_protcount{$cazy_group}++;}
	}
}
close(In);

open(Out,">$path/$fileout") || die "Cannot open file $fileout";
print Out "#Group\tProtein_count\n";
while (my ($k, $v)=each (%hash_group_protcount))
{
	print Out "$k\t$v\n";
}
close(Out);