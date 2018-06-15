=pod
December 1st 2014
This script is to read the manually checked tabular file format results from hmmscan and create for each gene the domain organization as followed:
Ex: REMTH_00010	GH13(evalue, HMM_fraction)|GT5(-,-) - CBM12
|: domains found in overlapping regions
-: domains found in separate regions

Modified on 10th December 2014
Input only onle file containing combined results from HMMSCAN and newHMMs
=cut

#! C:\Perl64\bin -w
use strict;
use Getopt::Long;
=pod
print "\nInput directory of input files: ";
my $pathin=<STDIN>;
chomp($pathin);

print "\nInput directory of output files: ";
my $pathout=<STDIN>;
chomp($pathout);

print "\nInput file containing hmmscan results (HMMSCAN + newHMMs)(location sorted): ";
my $file_hmmscan=<STDIN>;
chomp($file_hmmscan);

print "\nInput name of output file: ";
my $fileout=<STDIN>;
chomp($fileout);
=cut

my $pathin="";
my $pathout="";
my $file_hmmscan="";
my $fileout="";
GetOptions('pathin=s'=>\$pathin, 'file_hmmscan=s'=>\$file_hmmscan, 'pathout=s'=>\$pathout, 'fileout=s'=>\$fileout);
mkdir "$pathout";
my %hash_all_ids;

#############################################################################################################################
open(HMMSCAN,"<$pathin\/$file_hmmscan") || die "Cannot open file $pathin\/$file_hmmscan";
my %hash_HMMSCAN_info;
my %hash_HMMSCAN_end;
while (<HMMSCAN>)
{
	chomp($_);
	##Seq_id	CAZy_family	Evalue	HMM_fraction	HMM_from	HMM_to	HMM_len	Domain_from	Domain_to	Seq_len
	unless($_=~/Seq_id/)
	{
		#REMTH_001262 	CBM18	1.20E-07	84%	7	38	38	120	158	1945
		if ($_=~/(.+)\t(.+)\t(.+)\t(.+)\t.+\t.+\t.+\t(.+)\t(.+)\t.+/)
		{
			my $id=$1;
			my $family=$2;
			my $evalue=$3;
			my $fraction=$4;
			my $start=$5;
			my $end=$6;
			
			$hash_all_ids{$id}++;
			
			if ($hash_HMMSCAN_info{$id})
			{
				if ($hash_HMMSCAN_end{$id}>$start)
				{
					$hash_HMMSCAN_info{$id}=$hash_HMMSCAN_info{$id}.' | '.$family." (".$evalue." , ".$fraction." , ".$start." , ".$end.")";
					if ($hash_HMMSCAN_end{$id}<$end){$hash_HMMSCAN_end{$id}=$end;}
				}else
				{
					$hash_HMMSCAN_info{$id}=$hash_HMMSCAN_info{$id}." - ".$family." (".$evalue." , ".$fraction." , ".$start." , ".$end.")";
					$hash_HMMSCAN_end{$id}=$end;
				}
			}else
			{
				$hash_HMMSCAN_info{$id}=$family." (".$evalue." , ".$fraction." , ".$start." , ".$end.")";
				$hash_HMMSCAN_end{$id}=$end;
			}
		}else{print "Error: line in HMMSCAN file is not as described!\n$_\n";exit;}
	}
}
close(HMMSCAN);
#############################################################################################################################


#############################################################################################################################
open(Out,">$pathout\/$fileout") || die "Cannot open file $pathout\/$fileout";
print Out "#Seqid\tCAZy\n";
while (my ($k_id,$v)=each(%hash_all_ids))
{
	my $HMMSCAN_result=$hash_HMMSCAN_info{$k_id};
	print Out "$k_id\t$HMMSCAN_result\n";	
}
close(Out);
#############################################################################################################################