# October 6th 2015

#! /usr/perl/bin -w

=pod
print "\nInput working directory: ";
my $path=<STDIN>;
chomp($path);

print "\nInput folder containing CAZyme list with corresponding CAZy module: ";
my $folderin=<STDIN>;
chomp($folderin);

print "\nInput folder containing output files: ";
my $folderout=<STDIN>;
chomp($folderout);
=cut

my $path="/home/mnguyen/Research/Bacillus/CAZymes";
my $folderin="Best_domains_nosubfamily";
my $folderout="Bacillus_domain_count_nosubfamily";

mkdir "$path/$folderout";

opendir(DIR,"$path/$folderin") || die "Cannot open folder $path/$folderin";
my @files=readdir(DIR);
foreach my $filein (@files)
{
	unless (($filein eq ".") || ($filein eq ".."))
	{
		my $cmd="perl count_prot_domain_each_CAZy_family.pl --path $path --filein $folderin/$filein --fileout $folderout/$filein";
		system $cmd;
	}
}
closedir(DIR);