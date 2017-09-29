#! /usr/perl/bin -w

my $filein="dbCAN_HMMs_v6_noGH74_noCBM10.txt";
my $fileout="dbCAN_HMMs_v6_noGH74_noCBM10_hmm_length.txt";

open(In,"<$filein") || die "Cannot open file $filein";
open(Out,">$fileout") || die "Cannot open file $fileout";
while (<In>)
{
	$_=~s/\s*$//;
	#NAME  CBM11.hmm
	#LENG  163
	if ($_=~/^NAME\s+(.+\.hmm)/){print Out "$1\t";}
	if ($_=~/^LENG\s+(\d+)/){print Out "$1\n";}
}
close(In);
close(Out);