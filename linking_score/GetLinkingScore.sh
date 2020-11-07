#!/bin/sh

ind=$1
datadir=/ysm-gpfs/pi/gerstein/from_louise/gg487/1000genomes/

for ((i=1; i<=22; i++))
do

	awk '{if ($5>250 && $5<1250) {print $0}}' ${ind}.chr$i.candidate.snps.txt > ${ind}.chr$i.fromexp.txt
	awk -v var="$i" '{print "chr"var" "$0}' ${ind}.chr$i.fromexp.txt | awk '{if ($5=="0/1") {print $0}}' > ${ind}.tmp$i
	mv ${ind}.tmp$i ${ind}.chr$i.fromexp.txt
	awk 'NR==FNR{arr[$2$3$4];next} $1$2$3 in arr' ${ind}.chr$i.fromexp.txt ${datadir}/chr$i.matrix.1kg.txt > ${ind}.chr$i.newmat.snp.txt
	awk 'NR==FNR{arr[$1$2$3];next} $2$3$4 in arr {print $5}' ${ind}.chr$i.newmat.snp.txt ${ind}.chr$i.fromexp.txt > ${ind}.chr$i.gt.snp.txt
	./getinfomat ${ind}.chr$i.newmat.snp.txt ${ind}.chr$i.gt.snp.txt > ${ind}.chr$i.snp.info.ind.txt 

done 
