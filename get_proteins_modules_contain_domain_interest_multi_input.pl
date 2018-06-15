#! /usr/perl/bin -w
use strict;

my $folderin="";
my $folderout="";
my $filein_domains="";
mkdir "$folderout";

open(DOMAINS,"<$filein_domains") || die "Cannot open file $filein_domains";
my @domains;
while (<DOMAINS>)
{
	$_=~s/\s*//g;
	push(@domains,$_);
}
close(DOMAINS);

opendir(DIR,"$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
closedir(DIR);


foreach my $domain (@domains)
{
	my $fileout=$domain.".txt";
	my $cmd="perl get_proteins_modules_contain_domain_interest.pl --folderin $folderin --fileout $folderout/$fileout --domain $domain";
	system $cmd;
}


