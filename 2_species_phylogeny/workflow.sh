# Make directories
mkdir Genome_files/ # Make directory
mkdir Proteomes/ # Make directory
mkdir MarkerScannerOutput/ # Make directory
mkdir MarkerScannerSingle/ # Make directory
mkdir MarkerScannerCounted/ # Make directory
mkdir MarkerScannerGood/ # Make directory
mkdir Mafft/ # Make directory
mkdir Trimal/ # Make directory
mkdir TrimalModified/ # Make directory
mkdir Phylogeny/ # Make directory

# Download genomes
cp -r ../1_protein_phylogeny/Input_files/ . # Get genome list
perl Scripts/downloadGenomes.pl Input_files/genomeList.txt # download the genomes of interest

# Get the marker proteins - extract them
perl Scripts/switchNames.pl # Switch protein names
cat Proteomes/*.faa > combined_proteomes.faa # Combine the faa files into one file
rm Proteomes/*.faa # Remove unneeded files
perl Scripts/updateNumber.pl /datadisk1/Bioinformatics_programs/AMPHORA2/Scripts/MarkerScanner.pl # updates the number of sequences in the MarkerScanner.pl script
perl Scripts/MarkerScanner.pl -Bacteria combined_proteomes.faa # perform the MarkerScanner analysis
mv *.pep MarkerScannerOutput/ # Move output of MarkerScanner output directory
perl Scripts/extractSingle.pl # Extract proteins that are single copy
perl Scripts/countProteins.pl # Check that the proteins are found in enough genomes
perl Scripts/checkSpecies.pl # Check that in those genomes, the protein is found in single copy (probably redundant since the addition of extractSingle.pl)

# Run alignments and prepare concatenated alignment
perl Scripts/align_trim.pl # Run mafft on all individual sets of proteins
perl Scripts/modifyTrimAl.pl # Modify the trimAl output to prepare it for combining the alignments
perl Scripts/sortProteins.pl # Sort each of the trimAl output files that will be used for further analysis
perl Scripts/combineAlignments.pl > Phylogeny/MLSA_final_alignment.fasta # Concatenate the alignment files

# Make the phylogeny
cd Phylogeny/
#raxmlHPC-HYBRID-AVX2 -T 10 -s MLSA_final_alignment.fasta -N 5 -n test_phylogeny -f a -p 12345 -x 12345 -m PROTGAMMAAUTO
/datadisk1/Bioinformatics_programs/openmpi/bin/./mpiexec --map-by node -np 2 raxmlHPC-HYBRID-AVX2 -T 12 -s MLSA_final_alignment.fasta -N autoMRE -n MLSA_phylogeny -f a -p 12345 -x 12345 -m PROTGAMMALG
cd ..

