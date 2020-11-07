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
* find_candidate_snps.sh is the main script that calls the C++ file. 

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

## Step 2: Calculating Linking Score
* After creating candidate SNPs for the individual from their ASE gene list, go to folder linking_score
* GetLinkingScore.sh is the main script that calls the C++ file in the folder.

First, compile the C++ file by typing

``
g++ -o getinfomat getInfonewmat.cpp
``

Then,

``sh GetLinkingScore.sh <ind>
``

<ind> is the individual identifier (e.g. NA12878)
  
### Details of GetLinkingScore.sh
* ``awk '{if ($5>250 && $5<1250) {print $0}}' ${ind}.chr$i.candidate.snps.txt > ${ind}.chr$i.fromexp.txt`` : This line makes sure that the genotyping frequency of the SNP is above 0.1 and below 0.5
* ``awk -v var="$i" '{print "chr"var" "$0}' ${ind}.chr$i.fromexp.txt | awk '{if ($5=="0/1") {print $0}}' > ${ind}.tmp$i`` : This line makes sure that we are taking SNPs that are heterozygous at least for 1 individual in the database as those are the ones that can be used to capture ASE.
* ``mv ${ind}.tmp$i ${ind}.chr$i.fromexp.txt`` : To move the temporary file to a permanent one.
* ``awk 'NR==FNR{arr[$2$3$4];next} $1$2$3 in arr' ${ind}.chr$i.fromexp.txt ${datadir}/chr$i.matrix.1kg.txt > ${ind}.chr$i.newmat.snp.txt`` : Pruned candidate SNPs are overlapped with the 1000 Genomes matrices we created to make a new matrix, where rows are the candidate SNPs and columns are the 1000 Genomes individuals.
* ``awk 'NR==FNR{arr[$1$2$3];next} $2$3$4 in arr {print $5}' ${ind}.chr$i.newmat.snp.txt ${ind}.chr$i.fromexp.txt > ${ind}.chr$i.gt.snp.txt``: This creates a genotype file for the candidate SNPs of the individual. Since we only took the heterozygous ones, this file will have only "0/1" entries (as many as the number of pruned candidate SNPs).
* ``./getinfomat ${ind}.chr$i.newmat.snp.txt ${ind}.chr$i.gt.snp.txt > ${ind}.chr$i.snp.info.ind.txt`` : This looks at the candidate SNPs of all the individuals in the database and calculates a linking score for each of them by using self information. If an individual in the matrix has a genotype "0/1", then that individual for that SNP is a match. The contribution of that SNP to the linking score of the individual in the matrix is "log2 ( 1 / f ( SNP_genotype ) )"; the linking score for the individual in the matrix is the summation of the contribution of all matching genotypes. This will output a .txt file with 2504 entries (one entry for each individual in the databes), where each number corresponds to the linking score of the individual.


