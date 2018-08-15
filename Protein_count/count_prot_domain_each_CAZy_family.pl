=pod
December 10th 2014
This script is to count:
- The number of proteins containing domain of each CAZy family (if there is 1 protein containing 2 GH10 domains, then the number of proteins in GH10 family is 1)
- The number of domains detected for each CAZy family (if there is 1 protein containing 2 GH10 domains, then the number of detected GH10 family domain is 2)

Modified on February 4th 2015
Input: Cluster0067535	GH43.hmm (3.00E-50 , 96%) - CBM6.hmm (4.70E-13  , 86%) (2 columns)
Previously: Seq_id	Combined_dbCANv3_newHMMs	Best_hit_among_overlaps

Modified on February 19th 2015
Input: PIRRH_ORF_16073	PL3	PL3 (5.20E-45 , 65%)
Previously: PIRRH_ORF_16073	PL3 (5.20E-45 , 65%)

Modified on March 10th 2015
consider the column without e-value, hmm fraction information to count the proteins
=cut

#! /usr/perl/bin -w
use strict;
use Getopt::Long;

=pod
print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput file containing CAZy domain organization of each protein (in overlapping regions: there should be 1 best domain): ";
my $filein=<STDIN>;
chomp($filein);
my $fileout=substr($filein,0,-4);
$fileout=$fileout."_domain_prot_count.txt";

=cut

#my $path="/home/mnguyen/Research/Albert/InterProScan_v5/IPRScan_v5_26_65_06Nov2017_without_Panther/PFAMv31_best_domains";
#my $filein="Pirrh_PFAMv31_fromIPRScan.txt";
#my $fileout="Pirrh_PFAMv31_fromIPRScan_protcount.txt";
my $path;
my $filein;
my $fileout;
GetOptions('path=s'=>\$path, 'filein=s'=>\$filein, 'fileout=s'=>\$fileout);


open(In,"<$path/$filein") || die "Cannot open file $path/$filein";
open(Out,">$path/$fileout") || die "Cannot open file $fileout";
my %hash_prot_count;
my %hash_domain_count;
while (<In>)
{
	chomp($_);
	unless ($_=~/^\#/)
	{
		#Seq_id	CAZy_module	CAZy_module (evalue, HMM coverage, domain_start, domain_end)
		if ($_=~/.+\t(.+)\t.+/)
		#if ($_=~/.+\t(.+)/)
		{
			my $domain_org=$1;
			if ($domain_org=~/\-/)
			{
				my @domains=split(/ - /,$domain_org);
				my %hash_domains_each_prot;
				foreach my $domain (@domains)
				{
					$domain=~s/\s*//g;
					$hash_domain_count{$domain}++;
					$hash_domains_each_prot{$domain}++;
				}
				my @unique_domains=keys(%hash_domains_each_prot);
				foreach my $unique_domain (@unique_domains){$hash_prot_count{$unique_domain}++;}
			}
			else
			{
				$domain_org=~s/\s*//g;
				$hash_domain_count{$domain_org}++;
				$hash_prot_count{$domain_org}++;
			}
		}else{print "Error: Line in file $filein is not as described!\n$_\n";exit;}
	}
}
close(In);

print Out "#Family\tProtein_count\tDomain_count\n";
while (my ($k_family, $v_protcount)=each (%hash_prot_count))
{
	my $domain_count=$hash_domain_count{$k_family};
	print Out "$k_family\t$v_protcount\t$domain_count\n";
}
close(Out);