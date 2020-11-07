
ind=$1

#get linking scores from all chromosomes together
paste ${ind}.chr1.snp.info.ind.txt ${ind}.chr2.snp.info.ind.txt ${ind}.chr3.snp.info.ind.txt ${ind}.chr4.snp.info.ind.txt ${ind}.chr5.snp.info.ind.txt ${ind}.chr6.snp.info.ind.txt ${ind}.chr7.snp.info.ind.txt ${ind}.chr8.snp.info.ind.txt ${ind}.chr9.snp.info.ind.txt ${ind}.chr10.snp.info.ind.txt ${ind}.chr11.snp.info.ind.txt ${ind}.chr12.snp.info.ind.txt ${ind}.chr13.snp.info.ind.txt ${ind}.chr14.snp.info.ind.txt ${ind}.chr15.snp.info.ind.txt ${ind}.chr16.snp.info.ind.txt ${ind}.chr17.snp.info.ind.txt ${ind}.chr18.snp.info.ind.txt ${ind}.chr19.snp.info.ind.txt ${ind}.chr20.snp.info.ind.txt ${ind}.chr21.snp.info.ind.txt ${ind}.chr22.snp.info.ind.txt | awk '{print $1+$2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22}' > ${ind}.Allinfo.txt


#get the line of the maximum
lin=($(awk -v max=0 '{if($1>max){want=NR; max=$1}}END{print want}' ${ind}.Allinfo.txt))
#get the max
maximum=($(awk 'BEGIN{a=   0}{if ($1>0+a) a=$1} END{print a}' ${ind}.Allinfo.txt))
#get the second max
secmax=($(sort -rn ${ind}.Allinfo.txt | awk '{if (NR==2) {print $0}}'))

if [ "$secmax" = "0" ]; then
	echo "${ind} ${lin} ${maximum} ${secmax}" > ${ind}.gap.txt
else
	gap=$(echo $maximum/$secmax | bc -l)
	echo "${ind} ${lin} ${gap} ${secmax} " > ${ind}.gap.txt
fi


