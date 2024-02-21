# Prepare directories
mkdir Genome_files/ # Make directory
mkdir hmmDatabaseFiles/ # Make directory
mkdir HMMsearch/ # Make directory
mkdir HMMsearchParsed/ # Make directory
mkdir HMMsearchHits/ # Make directory
mkdir HMMscan/ # Make directory
mkdir HMMscanParsed/ # Make directory
mkdir HMMscanTop/ # Make directory
mkdir HMMscanTopLists/ # Make directory
mkdir BacA_proteins/ # Make directory
mkdir Phylogeny/ # Make directory

# Download genomes
perl Scripts/parseGenomeList.pl Input_files/BacA.csv # Parse the NCBI genome table to get info to download genomes.
sed -i 's/;/_/g' Input_files/genomeList.txt
sed -i 's/:_/_/g' Input_files/genomeList.txt
sed -i 's/(/_/g' Input_files/genomeList.txt
sed -i 's/)/_/g' Input_files/genomeList.txt
sed -i 's/\[/_/g' Input_files/genomeList.txt
sed -i 's/\]/_/g' Input_files/genomeList.txt
sed -i 's/-/_/g' Input_files/genomeList.txt
sed -i 's/#/_/g' Input_files/genomeList.txt
sed -i 's/=/_/g' Input_files/genomeList.txt
sed -i 's/SC\/BZ/SC_BZ/' Input_files/genomeList.txt
sed -i 's/M327\/99\/2/M327_99_2/' Input_files/genomeList.txt
sed -i 's/1403\/13f/1403_13f/' Input_files/genomeList.txt
sed -i 's/918\/95b/918_95b/' Input_files/genomeList.txt
sed -i 's/V5\/3M/V5_3M/' Input_files/genomeList.txt
sed -i 's/JW\/NM/JW_NM/' Input_files/genomeList.txt
sed -i 's/35\/02/35_02/' Input_files/genomeList.txt
sed -i 's/M3\/6/M3_6/' Input_files/genomeList.txt
sed -i 's/80\/3/80_3/' Input_files/genomeList.txt
sed -i 's/24\/)/24_0/' Input_files/genomeList.txt
sed -i 's/24\/O/24_o/' Input_files/genomeList.txt
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/sp._/sp_/' Input_files/genomeList.txt # Fix sp._ to sp_
sed -i 's/_\t/\t/g' Input_files/genomeList.txt
sort -u -k1,1 Input_files/genomeList.txt > temp.txt # Remove duplicates- save it as a temp file
mv temp.txt Input_files/genomeList.txt # Rename the file - cuz we can’t rewrite/ re-save it directly
perl Scripts/downloadGenomes.pl Input_files/genomeList.txt # download the genomes of interest
ls -1 Genome_files/ | sed 's/\.gbff//' > temp.txt # Find missing genomes
grep -f temp.txt Input_files/genomeList.txt > temp2.txt # Remove missing genomes from genomeList
mv temp2.txt Input_files/genomeList.txt
rm temp.txt

# Extract protein sequences
perl Scripts/extractFaaFromGBFF.pl # Make faa files from the GenBank files
perl Scripts/modifyFasta.pl combined_proteomes_HMM.faa > combined_proteomes_HMM_modified.faa # Modify the fasta file for easy extraction

# Download HMM databases
wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam33.1/Pfam-A.hmm.gz # get the Pfam HMM files
wget ftp://ftp.jcvi.org/pub/data/TIGRFAMs/TIGRFAMs_15.0_HMM.LIB.gz # get the TIGRFAM HMM files
wget https://ftp.ncbi.nih.gov/pub/mmdb/cdd/fasta.tar.gz # Download CDD database
tar -xzf fasta.tar.gz # Unzip CDD database
mv PRK11098.FASTA hmmDatabaseFiles/ # Move file
mv COG1133.FASTA hmmDatabaseFiles/ # Move file
rm *.FASTA # Remove unwanted files
mv fasta.tar.gz hmmDatabaseFiles/ # Move file
cp Input_files/HMM_files/*.hmm hmmDatabaseFiles/ # Copy files
hmmbuild hmmDatabaseFiles/PRK11098.hmm hmmDatabaseFiles/PRK11098.FASTA
hmmbuild hmmDatabaseFiles/COG1133.hmm hmmDatabaseFiles/COG1133.FASTA
gunzip Pfam-A.hmm.gz # unzip the Pfam files
gunzip TIGRFAMs_15.0_HMM.LIB.gz # unzip the TIGRFAM files
mv Pfam-A.hmm hmmDatabaseFiles/Pfam-A.hmm # move the Pfam files
mv TIGRFAMs_15.0_HMM.LIB hmmDatabaseFiles/TIGRFAMs_15.0_HMM.LIB # move the TIGRFAM files
hmmconvert hmmDatabaseFiles/Pfam-A.hmm > hmmDatabaseFiles/Pfam-A_converted.hmm # convert the database to the necessary format
hmmconvert hmmDatabaseFiles/TIGRFAMs_15.0_HMM.LIB > hmmDatabaseFiles/TIGRFAM_converted.hmm # convert the database to the necessary format
hmmconvert hmmDatabaseFiles/PRK11098.hmm > hmmDatabaseFiles/PRK11098_converted.hmm # convert the database to the necessary format
hmmconvert hmmDatabaseFiles/COG1133.hmm > hmmDatabaseFiles/COG1133_converted.hmm # convert the database to the necessary format
hmmconvert hmmDatabaseFiles/BacA.hmm > hmmDatabaseFiles/BacA_converted.hmm
hmmconvert hmmDatabaseFiles/BclA.hmm > hmmDatabaseFiles/BclA_converted.hmm
hmmconvert hmmDatabaseFiles/Bradyrhizobium_BacA_like.hmm > hmmDatabaseFiles/Bradyrhizobium_BacA_like_converted.hmm
hmmconvert hmmDatabaseFiles/ExsE.hmm > hmmDatabaseFiles/ExsE_converted.hmm
hmmconvert hmmDatabaseFiles/Mycobacterium_BacA.hmm > hmmDatabaseFiles/Mycobacterium_BacA_converted.hmm
cat hmmDatabaseFiles/Pfam-A_converted.hmm hmmDatabaseFiles/TIGRFAM_converted.hmm hmmDatabaseFiles/PRK11098_converted.hmm hmmDatabaseFiles/COG1133_converted.hmm hmmDatabaseFiles/BacA_converted.hmm hmmDatabaseFiles/BclA_converted.hmm hmmDatabaseFiles/Bradyrhizobium_BacA_like_converted.hmm hmmDatabaseFiles/ExsE_converted.hmm hmmDatabaseFiles/Mycobacterium_BacA_converted.hmm > hmmDatabaseFiles/converted_combined.hmm # combined all hidden Markov models into a single file
hmmpress hmmDatabaseFiles/converted_combined.hmm # prepare files for hmmscan searches

# Perform the HMMsearch screens
perl Scripts/performHMMsearch.pl # A short script to repeat for all HMM files, the build, hmmsearch, parsing, and hit extraction

# Perform the HMM scan screens
perl Scripts/performHMMscan.pl # A short script to repeat for all the HMM search output files, to perform hmmscan, parse, and hit extraction
pigz -r -p 24 hmmDatabaseFiles/ # Compress files

# Determine strains with each protein
perl Scripts/determineProteinPresence.pl > BacA_distribution.txt # determine which of the six proteins are in each of the strains

# Extract proteins
perl Scripts/extractHMMscanHits.pl # extract all the BacA and related proteins

# Phylogeny
clustalo --threads=24 -i BacA_proteins/BacA_top.faa -o Phylogeny/BacA_alignment.fasta --force # Align proteins with clustal omega
trimal -in Phylogeny/BacA_alignment.fasta -out Phylogeny/BacA_alignment_trimmed.fasta -automated1 # Trim alignment
cd Phylogeny/
#raxmlHPC-HYBRID-AVX2 -T 10 -s BacA_alignment_trimmed.fasta -N 5 -n test_phylogeny -f a -p 12345 -x 12345 -m PROTGAMMAAUTO
/datadisk1/Bioinformatics_programs/openmpi/bin/./mpiexec --map-by node -np 12 raxmlHPC-HYBRID-AVX2 -T 2 -s BacA_alignment_trimmed.fasta -N autoMRE -n BacA_phylogeny -f a -p 12345 -x 12345 -m PROTGAMMALG
cd ..

