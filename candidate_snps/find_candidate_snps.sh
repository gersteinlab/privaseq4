#!/bin/sh

datadir=/ysm-gpfs/pi/gerstein/from_louise/gg487/1000genomes/
ind=$1


for ((i=1; i<=22; i++))
do

	./overlap ${datadir}/chr$i.freq.txt ${ind}.ASE.exon.locations.txt chr$i > tmp$i
	awk '!seen[$0]++' tmp$i > ${ind}.chr$i.candidate.snps.txt
	rm tmp$i

done



