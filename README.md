# Recovering genomes and phenotypes using allele-specific gene expression

## DATA

### Genotypes
* 1000 Genomes vcf files for all of the chromosomes are downloaded from ftp locations in https://www.internationalgenome.org
* We converted the vcf files into a simple matrix by only printing the location, reference and alternative alleles, and the genotypes for all of the individuals.
First 100 SNPs from Chr22 in this new matrix form can be found as data/example.chr22.matrix.1kg.txt as an example.

### ASE genes
* A gene list for each individual is taken from http://alleledb.gersteinlab.org. The txt file that has the genes in the first column and individual IDs in the second column can be found at data/genesVSinds.txt
* For each individual, we found the locations of all the exons using Gencode's GRCh37 annotation file from ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_35/GRCh37_mapping/gencode.v35lift37.annotation.gtf.gz
* We reported ASE exon locations for each individual in data/exon_locations.zip

## Step 1: Finding candidate SNPs
