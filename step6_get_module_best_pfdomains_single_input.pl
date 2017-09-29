=pod
December 3rd 2014
This script is to select the best CAZy family assignment among those found in overlapping regions
(Hit having the lowest e-value is selected)

Modified on February 5th 2015
Only print best CAZy domain among the overlapped ones
Output should be as followed:
Protein_ID	CAZy_module(no evalue, no HMM fraction)	CAZy_module(evalue, HMM fraction)
=cut

#! /usr/perl/bin -w
use strict;
use Getopt::Long;

=pod
print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput text file containing gene id and their CAZy assignment: ";
my $filein=<STDIN>;
chomp($filein);

my $fileout=substr($filein,0,-4);
$fileout=$fileout."_best_hits_among_overlaps.txt";
=cut


my $path="";
my $filein="";
my $fileout="";
GetOptions('path=s'=>\$path, 'filein=s'=>\$filein, 'fileout=s'=>\$fileout);

open(In,"<$path/$filein") || die "Cannot open file $filein";
open(Out,">$path/$fileout") || die "Cannot open file $fileout";
print Out "#Seq_id\tCAZy_module\tCAZy_module (evalue, HMM coverage, domain_start, domain_end)\n";
while (<In>)
{
	unless($_=~/^\#/)
	{
		chomp($_);
		if ($_=~/(.*)\t(.*)/)
		{
			my $id=$1;
			my $cazy=$2;
			$id=~s/\s*//g;
			
			#CBM48 (6.30E-11 , 61%) - GH13_fungi (3.60E-56 , 94%)
			if ($cazy=~/ - /)
			{
				my @regions=split(/ \- /,$cazy);
				my $new_cazy="";
				my $new_cazy_brief="";
				foreach my $region (@regions)
				{
					if ($region=~/ \| /)
					{
						my $selected_family="";
						my $selected_family_brief="";
						my $lowest_evalue=10;
						$region=~s/ \| / \; /g;
						my @families=split(/ \; /,$region);
						foreach my $family (@families)
						{
							if ($family=~/(.+)\s*\((.+)\s*\,\s*(\d+\%)\s*\,\s*(\d+)\s*\,\s*(\d+)\)/)
							{
								my $cazy_family=$1;
								my $evalue=$2;
								my $hmm_fraction=$3;
								my $start=$4;
								my $end=$5;
								$cazy_family=~s/\s*//g;
								$cazy_family=~s/\.\d+//;
								if ($evalue<$lowest_evalue)
								{
									$lowest_evalue=$evalue;
									$selected_family=$cazy_family." (".$lowest_evalue." , ".$hmm_fraction." , ".$start." , ".$end.")";
									$selected_family_brief=$cazy_family;
								}
							}else{print "Family information is not as described:\nGene: -$id-\nFamily: -$family- \n";exit;}
						}
						if ($new_cazy){$new_cazy=$new_cazy." - ".$selected_family;$new_cazy_brief=$new_cazy_brief." - ".$selected_family_brief;}
						else{$new_cazy=$selected_family;$new_cazy_brief=$selected_family_brief;}
					}else
					{
						my $region_brief=$region;
						$region_brief=~s/\.\d+\s*\(.+//;
						if ($new_cazy){$new_cazy=$new_cazy." - ".$region;$new_cazy_brief=$new_cazy_brief." - ".$region_brief;}
						else{$new_cazy=$region;$new_cazy_brief=$region_brief;}
					}
				}
				print Out "$id\t$new_cazy_brief\t$new_cazy\n";
			}else
			{
				# GT81 (2.70E-12 , 43%) | GT27 (2.20E-10 , 39%) | GT2 (4.80E-44 , 100%)
				if ($cazy=~/ \| /)
				{
					my $selected_family="";
					my $selected_family_brief="";
					my $lowest_evalue=10;
					$cazy=~s/ \| / \; /g;
					my @families=split(/ \; /,$cazy);
					foreach my $family (@families)
					{
						if ($family=~/(.+)\s*\((.+)\s*\,\s*(\d+\%)\s*\,\s*(\d+)\s*\,\s*(\d+)\)/)
						{
							
							my $cazy_family=$1;
							my $evalue=$2;
							my $hmm_fraction=$3;
							my $start=$4;
							my $end=$5;
							$cazy_family=~s/\s*//g;
							$cazy_family=~s/\.\d+//;
							if ($evalue<$lowest_evalue)
							{
								$lowest_evalue=$evalue;
								$selected_family=$cazy_family." (".$lowest_evalue." , ".$hmm_fraction." , ".$start." , ".$end.")";
								$selected_family_brief=$cazy_family;
							}
						}else{print "Family information is not as described:\nGene: $id\nFamily: $family \n";exit;}
					}
					print Out "$id\t$selected_family_brief\t$selected_family\n";
				}else
				{
					my $original_cazy=$cazy;  #PF05378.11 (1.10E-26 , 99% , 6 , 188)
					$cazy=~s/\.\d+\s*\(.+//;
					print Out "$id\t$cazy\t$original_cazy\n";
				}
			}
		}else{print "Error: Line in file $filein is not as described\n$_";exit;}
	}
}
close(In);
close(Out);
