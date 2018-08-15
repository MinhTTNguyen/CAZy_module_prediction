=pod
February 6th 2015
This script in to print out all CAZy modules and corresponding protein counts in all rumen samples, Bospr and Musox
Input: 3 files containing CAZy_module and protein_count of all rumen samples, Bospr and Musox
Output: 1 table compiled from the 3 input tables
=cut

#! C:\Perl64\bin -w
use strict;
use Getopt::Long;

my $filein_allsamples="";
my $fileins_ruminants="";
my $path="";
my $fileout="";
# '--fileins_ruminants=s'=>\$fileins_ruminants: file names are separated by ","
GetOptions('--filein_allsamples=s'=>\$filein_allsamples,'--fileins_ruminants=s'=>\$fileins_ruminants, '--fileout=s'=>\$fileout, '--path_ruminant=s'=>\$path);

my @fileins_ruminants_arr=split(/,/,$fileins_ruminants);

#######################################################################################################
# read data from tables of different ruminants
my %hash_ruminant_CaZymodule_protcount;
foreach my $filein_ruminant (@fileins_ruminants_arr)
{
	open(Ruminant,"<$path\\$filein_ruminant") || die "Cannot open file $filein_ruminant";
	my $ruminant=substr($filein_ruminant,-9);
	$ruminant=~s/\.txt$//;
	while (<Ruminant>)
	{
		unless ($_=~/^\#/)
		{
			chomp($_);
			my @columns=split(/\t/,$_);
			my $cazy=$columns[0];
			my $protcount=$columns[1];
			$cazy=~s/\s*//g;
			my $key=$ruminant."_".$cazy;
			
			$hash_ruminant_CaZymodule_protcount{$key}=$protcount;
		}
	}
	close(Ruminant);
}
########################################################################################################




########################################################################################################
open(ALL,"<$filein_allsamples") || die "Cannot open file $filein_allsamples";
open(Out,">$fileout") || die "Cannot open file $fileout";
while (<ALL>)
{
	chomp($_);
	if ($_=~/^\#/)
	{
		my @column_labels=split(/\t/,$_);
		shift(@column_labels);
		shift(@column_labels);
		my $last_columns=join("\t",@column_labels);
		my $first_cloumns="#CAZy_module\tAll_samples";
		foreach my $filein_ruminant (@fileins_ruminants_arr)
		{
			my $ruminant=substr($filein_ruminant,-9);$ruminant=~s/\.txt$//;
			$first_cloumns=$first_cloumns."\t".$ruminant;
		}
		my $first_row=$first_cloumns."\t".$last_columns;
		print Out "$first_row\n";
	}else
	{
		my @columns=split(/\t/,$_);
		my $module=shift(@columns);
		my $protcount_all=shift(@columns);
		my $last_columns=join("\t",@columns);
		my $first_cloumns="$module\t$protcount_all";
		$module=~s/\s*//g;
		foreach my $filein_ruminant (@fileins_ruminants_arr)
		{
			my $ruminant=substr($filein_ruminant,-9);$ruminant=~s/\.txt$//;
			my $key=$ruminant."_".$module;
			my $protcount_ruminant=$hash_ruminant_CaZymodule_protcount{$key};
			unless ($protcount_ruminant){$protcount_ruminant=0;}
			$first_cloumns=$first_cloumns."\t".$protcount_ruminant;
		}
		my $row=$first_cloumns."\t".$last_columns;
		print Out "$row\n";
	}
}
close(ALL);
close(Out);
########################################################################################################