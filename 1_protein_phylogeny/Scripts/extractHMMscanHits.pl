#!usr/bin/perl
use 5.010;

# List of files
$genePresence = 'BacA_distribution.txt';
$BacA_file = 'HMMscanTop/SbmA_BacA.csv';
$BacA_out_file = 'HMMscanTopLists/SbmA_BacA.txt';

# Find strains with all flagellin proteins
open($presence, '<', $genePresence);
while(<$presence>) {
	$_ =~ s/___/__/;
	@line = split("\t", $_);
	if(@line[1] + @line[2] + @line[3] + @line[4] + @line[5] != 0) {
		push(@species, @line[0]);
	}
}
close($presence);

# Get BacA and related proteins
open($BacA,'<',$BacA_file);
open($BacA_out,'>',$BacA_out_file);
while(<$BacA>) {
	@line = split(',',$_);
	if(@line[9] eq 'SbmA_BacA' || @line[9] eq 'PRK11098' || @line[9] eq 'COG1133' || @line[9] eq 'BacA_alignment' || @line[9] eq 'BclA_alignment' || @line[9] eq 'Mycobacterium_BacA_alignment' || @line[9] eq 'ExsE_alignment' || @line[9] eq 'Bradyrhizobium_BacA_other_alignment') {
		@line2 = split('__', @line[0]);
		foreach $i (@species) {
			if(@line2[0] eq $i) {
				say $BacA_out (@line[0]);
			}
		}
	}

}
close($BacA);
close($BacA_out);
system("grep -f 'HMMscanTopLists/SbmA_BacA.txt' combined_proteomes_HMM_modified.faa > BacA_proteins/BacA_top.faa");

$temp_file = 'temp.faa';
$final_out = 'BacA_proteins/BacA_top.faa';
open($in, '<', $final_out);
open($out, '>', $temp_file);
while(<$in>) {
	$_ =~ s/\t/\n/;
	print $out ($_);
}
close($in);
close($out);
system("mv temp.faa BacA_proteins/BacA_top.faa");

