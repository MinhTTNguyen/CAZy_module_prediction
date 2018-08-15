=pod
February 2nd 2015
This script is to add activity information of CAZy families into the "CAZy_module - prot_count" table
Activity information was obtained from FamInfo.txt file from dbCAN v3

Modified on February 6th 2015
Include GT families in the table
=cut

#! C:\Perl64\bin -w
use strict;
use Getopt::Long;

my $filein_cazymodule="";
my $filein_activity="";
my $path="";
GetOptions('in_cazy=s'=>\$filein_cazymodule, 'in_act=s'=>\$filein_activity, '-out_path=s'=>\$path );

my $fileout=substr($filein_cazymodule,0,-4);
$fileout=$fileout."_add_activity.txt";

######################################################################################################
# read table containing CAZy families and their activities (dbCAN v3)
open(Activity,"<$filein_activity") || die "Cannot open file $filein_activity";
my %hash_cazy_activity;
while (<Activity>)
{
	chomp($_);
	unless ($_=~/^\#/)
	{
		my @columns=split(/\t/,$_);
		my $family=shift(@columns);
		my $activity=pop(@columns);
		$hash_cazy_activity{$family}=$activity;
	}
}
close(Activity);
######################################################################################################


######################################################################################################
open(In,"<$path\\$filein_cazymodule") || die "Cannot open file $filein_cazymodule";
open(Out,">$path\\$fileout") || die "Cannot open file $fileout";

while (<In>)
{
	chomp($_);
	if ($_=~/^\#/)
	{
		print Out "$_\tGH\tCE\tPL\tAA\tCBM\tCellulosome\tGT\n";
	}else
	{
		my @columns=split(/\t/,$_);
		my $module=$columns[0];
		$module=~s/\s*//g;
		my %hash_families_in_module;
		
		my @families=split(/-/,$module);
		foreach my $family (@families){$hash_families_in_module{$family}++;}
		
		my ($gh, $ce, $pl, $aa, $cbm, $cellolosome, $gt)="";
		
		while (my ($k_fami, $v_count)=each (%hash_families_in_module))
		{
			my $activity=$hash_cazy_activity{$k_fami};
			unless($activity){$activity="No activity description in dbCAN";}
			if ($k_fami=~/GH\d+/)
			{
				if ($gh){$gh=$gh." | ".$k_fami.":".$activity;}
				else{$gh=$k_fami.":".$activity;}
			}
			
			if ($k_fami=~/CE\d+/)
			{
				if ($ce){$ce=$ce." | ".$k_fami.":".$activity;}
				else{$ce=$k_fami.":".$activity;}
			}
			
			if ($k_fami=~/PL\d+/)
			{
				if ($pl){$pl=$pl." | ".$k_fami.":".$activity;}
				else{$pl=$k_fami.":".$activity;}
			}
				
			if ($k_fami=~/AA\d+/)
			{
				if ($aa){$aa=$aa." | ".$k_fami.":".$activity;}
				else{$aa=$k_fami.":".$activity;}
			}
			
			if ($k_fami=~/CBM\d+/)
			{
				if ($cbm){$cbm=$cbm." | ".$k_fami.":".$activity;}
				else{$cbm=$k_fami.":".$activity;}
			}
			
			if (($k_fami=~/cohesin/) || ($k_fami=~/dockerin/) || ($k_fami=~/SLH/))
			{
				if ($cellolosome){$cellolosome=$cellolosome." | ".$k_fami.":".$activity;}
				else{$cellolosome=$k_fami.":".$activity;}
			}
			
			if ($k_fami=~/GT\d+/)
			{
				if ($gt){$gt=$gt." | ".$k_fami.":".$activity;}
				else{$gt=$k_fami.":".$activity;}
			}
		}
		print Out "$_\t$gh\t$ce\t$pl\t$aa\t$cbm\t$cellolosome\t$gt\n";
	}
}
close(In);
close(Out);
######################################################################################################