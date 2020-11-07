# Recovering genomes and phenotypes using allele-specific gene expression

## DATA

### Genotypes
* 1000 Genomes vcf files for all of the chromosomes are downloaded from ftp locations in https://www.internationalgenome.org
* We converted the vcf files into a simple matrix by only printing the location, reference and alternative alleles, and the genotypes for all of the individuals.
First 100 SNPs from Chr22 in this new matrix form can be found as data/example.chr22.matrix.1kg.txt as an example.
* We also created a txt file that contains the frequency of homozygous and heterozygous alternative alleles in 1000 Genomes data for each chromosome. First 100 SNPs from Chr22 in this form can be found as data/example.chr22.freq.txt

### ASE genes
* A gene list for each individual is taken from http://alleledb.gersteinlab.org. The txt file that has the genes in the first column and individual IDs in the second column can be found at data/genesVSinds.txt
* For each individual, we found the locations of all the exons using Gencode's GRCh37 annotation file from ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz
* We reported ASE exon locations for each individual in data/exon_locations.zip

## Step 1: Finding candidate SNPs
* Go to folder candidate_snps
* find_candidate_snps.sh is the main script that call the C++ file. 

First, compile the C++ file by typing

``
g++ -o overlap Overlap.cpp
``

Then,

``
sh find_candidate_snps.sh <ind>
``

<ind> is the individual identifier (e.g. NA12878)

### Details of find_candidate_snps.sh
* ``./overlap ${datadir}/chr$i.freq.txt ${ind}.ASE.exon.locations.txt chr$i > tmp$i`` : This line takes the exon locations and overlaps it with all the SNPs found in 1000 Genomes and reports the genotyping frequencies of the SNPs.
* ``awk '!seen[$0]++' tmp$i > ${ind}.chr$i.candidate.snps.txt`` : This line makes sure there is no duplicate SNPs.
* ``rm tmp$i`` : Removes temporary file



