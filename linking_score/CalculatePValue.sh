#!/bin/sh

ind=$1
datadir=/ysm-gpfs/pi/gerstein/from_louise/gg487/1000genomes

for ((j=0; j<1000; j++))
do
	for ((i=1; i<=22; i++))
	do
		a=($(wc -l ${ind}.chr$i.fromexp.txt))
		shuf -n $a ${datadir}/chr$i.freq.txt > tmp
		sort -k2,2n tmp > ${ind}.chr$i.random.txt
		rm tmp
		awk 'NR==FNR{arr[$2$3$4];next} $1$2$3 in arr' chr$i.random.txt ${datadir}/chr$i.matrix.1kg.txt > ${ind}.chr$i.newmat.rand.snp.txt
		awk 'NR==FNR{arr[$1$2$3];next} $2$3$4 in arr {print $5}' ${ind}.chr$i.newmat.rand.snp.txt ${ind}.chr$i.random.txt > ${ind}.chr$i.gt.rand.snp.txt 
		field="$(awk '{print NF}' chr$i.newmat.rand.snp.txt | head -n 1)"
		number=`echo "$((field-3))"`
		./getinfomat ${ind}.chr$i.newmat.rand.snp.txt ${ind}.chr$i.gt.rand.snp.txt $number > ${ind}.chr$i.random.snp.info.ind.txt 

	done
	paste ${ind}.chr1.random.snp.info.ind.txt ${ind}.chr2.random.snp.info.ind.txt ${ind}.chr3.random.snp.info.ind.txt ${ind}.chr4.random.snp.info.ind.txt ${ind}.chr5.random.snp.info.ind.txt ${ind}.chr6.random.snp.info.ind.txt ${ind}.chr7.random.snp.info.ind.txt ${ind}.chr8.random.snp.info.ind.txt ${ind}.chr9.random.snp.info.ind.txt ${ind}.chr10.random.snp.info.ind.txt ${ind}.chr11.random.snp.info.ind.txt ${ind}.chr12.random.snp.info.ind.txt ${ind}.chr13.random.snp.info.ind.txt ${ind}.chr14.random.snp.info.ind.txt ${ind}.chr15.random.snp.info.ind.txt ${ind}.chr16.random.snp.info.ind.txt ${ind}.chr17.random.snp.info.ind.txt ${ind}.chr18.random.snp.info.ind.txt ${ind}.chr19.random.snp.info.ind.txt ${ind}.chr20.random.snp.info.ind.txt ${ind}.chr21.random.snp.info.ind.txt ${ind}.chr22.random.snp.info.ind.txt | awk '{print $1+$2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22}' > ${ind}.random_info.txt	
	#get the line of the maximum
	lin=($(awk -v max=0 '{if($1>max){want=NR; max=$1}}END{print want}' ${ind}.random_info.txt))
	#get the max
	maximum=($(awk 'BEGIN{a=   0}{if ($1>0+a) a=$1} END{print a}' ${ind}.random_info.txt))
	#get the second max
	secmax=($(sort -rn ${ind}.random_info.txt | awk '{if (NR==2) {print $0}}'))
	if [ "$secmax" = "0" ]; then
        	echo "$lin $maximum $secmax" >> ${ind}.random.gaps.txt
	else
        	gap=$(echo $maximum/$secmax | bc -l)
        	echo "$lin $gap $secmax" >> ${ind}.random.gaps.txt
	fi
done


