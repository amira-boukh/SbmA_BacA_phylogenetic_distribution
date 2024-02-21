#!usr/bin/perl
use 5.010;

# List of files
$strainFile = 'Input_files/genomeList.txt';
$BacA_file = 'HMMscanTop/SbmA_BacA.csv';

# Prepare lists of strain/species names
open($strainList,'<',$strainFile);
while(<$strainList>) {
	chomp;
	@strainLine = split("\t",$_);
	@strainLine2 = split('_',@strainLine[0]);
	$partialStrain = "@strainLine2[0]_@strainLine2[1]";
	push(@strainsFull,@strainLine[0]);
	push(@strainsPartial,$partialStrain);
	push(@species,$partialStrain);
}

# Determine presence of BacA
say("Strain\tBacA\tBclA\tMycobacterium_BacA\tExsE\tBradyrhizobium_other_BacA");
$count = -1;
foreach $i (@strainsFull) {
	$count++;
	@hitArray = qw( 0 0 0 0 0 );
	open($BacA,'<',$BacA_file);
	while(<$BacA>) {
		if(/$i/) {
			@line = split(',',$_);
			if(@line[9] eq 'SbmA_BacA') {
				@hitArray[0] = '1';
			}
			elsif(@line[9] eq 'PRK11098') {
				@hitArray[0] = '1';
			}
			elsif(@line[9] eq 'COG1133') {
				@hitArray[0] = '1';
			}
			elsif(@line[9] eq 'BacA_alignment') {
				@hitArray[0] = '1';
			}
			elsif(@line[9] eq 'BclA_alignment') {
				@hitArray[1] = '1';
			}
			elsif(@line[9] eq 'Mycobacterium_BacA_alignment') {
				@hitArray[2] = '1';
			}
			elsif(@line[9] eq 'ExsE_alignment') {
				@hitArray[3] = '1';
			}
			elsif(@line[9] eq 'Bradyrhizobium_BacA_other_alignment') {
				@hitArray[4] = '1';
			}

		}
	}
	close($BacA);
	say("@strainsFull[$count]\t@hitArray[0]\t@hitArray[1]\t@hitArray[2]\t@hitArray[3]\t@hitArray[4]");
}

