# Recovering genotypes and phenotypes using allele-specific genes

## Data

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

``<ind>`` is the individual identifier (e.g. NA12878)

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

``<ind>`` is the individual identifier (e.g. NA12878)
  
### Details of GetLinkingScore.sh
* ``awk '{if ($5>250 && $5<1250) {print $0}}' ${ind}.chr$i.candidate.snps.txt > ${ind}.chr$i.fromexp.txt`` : This line makes sure that the genotyping frequency of the SNP is above 0.1 and below 0.5
* ``awk -v var="$i" '{print "chr"var" "$0}' ${ind}.chr$i.fromexp.txt | awk '{if ($5=="0/1") {print $0}}' > ${ind}.tmp$i`` : This line makes sure that we are taking SNPs that are heterozygous at least for 1 individual in the database as those are the ones that can be used to capture ASE.
* ``mv ${ind}.tmp$i ${ind}.chr$i.fromexp.txt`` : To move the temporary file to a permanent one.
* ``awk 'NR==FNR{arr[$2$3$4];next} $1$2$3 in arr' ${ind}.chr$i.fromexp.txt ${datadir}/chr$i.matrix.1kg.txt > ${ind}.chr$i.newmat.snp.txt`` : Pruned candidate SNPs are overlapped with the 1000 Genomes matrices we created to make a new matrix, where rows are the candidate SNPs and columns are the 1000 Genomes individuals.
* ``awk 'NR==FNR{arr[$1$2$3];next} $2$3$4 in arr {print $5}' ${ind}.chr$i.newmat.snp.txt ${ind}.chr$i.fromexp.txt > ${ind}.chr$i.gt.snp.txt``: This creates a genotype file for the candidate SNPs of the individual. Since we only took the heterozygous ones, this file will have only "0/1" entries (as many as the number of pruned candidate SNPs).
* ``./getinfomat ${ind}.chr$i.newmat.snp.txt ${ind}.chr$i.gt.snp.txt > ${ind}.chr$i.snp.info.ind.txt`` : This looks at the candidate SNPs of all the individuals in the database and calculates a linking score for each of them by using self information. If an individual in the matrix has a genotype "0/1", then that individual for that SNP is a match. The contribution of that SNP to the linking score of the individual in the matrix is "log2 ( 1 / f ( SNP_genotype ) )"; the linking score for the individual in the matrix is the summation of the contribution of all matching genotypes. This will output a .txt file with 2504 entries (one entry for each individual in the databes), where each number corresponds to the linking score of the individual.

## Step 3: Calculating the gap score
* Run the CalculateGap.sh in the linking_score folder by typing

``
sh CalculateGap.sh <ind>
``

``<ind>`` is the individual identifier (e.g. NA12878). This will produce a ``<ind>.gap.txt`` file that has 4 columns. First column is the individual identifier, second column is the column number of the matching individual. For example, if it is 5; that means it matches to the 5th individual in the 1000 Genomes vcf file. Third column is the value of the gap, which is the ratio between the highest linking score and second highest linking score. Forth column is the value of the second highest linking score for sanity check.

### Details of CalculateGap.sh
* First, it combines and sums linking scores from all of the chromosomes.
* It finds the best and second best linking scores and takes the ratio.
* It reports the ratio (gap) and the matching individual (in therms of column number in 1000 Genomes)

## Step 3: Calculating the p-value
* Run the CalculatePValue.sh in the linking_score by typing

``
sh CalculatePValue.sh <ind>
``

``<ind>`` is the individual identifier (e.g. NA12878). This will produce a ``<ind>.random.gaps.txt`` file that has 4 columns (same as above) and 1000 rows coming from 1000 random trials. You can then compare the gap value in ``<ind>.gap.txt`` to the values in ``<ind>.random.gaps.txt`` and count the number of times the real gap score was same or below the random scores. This count divided by 1000 (number of trials) will give you the p-value for the gap value in ``<ind>.gap.txt`` .

