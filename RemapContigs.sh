
IndexedContigs=$1

for file in *_1_*;do echo novoalign -d $IndexedContigs -f $file ${file%1_sequence.fastq}2_sequence.fastq  -o SAM \> ${file%_1_sequence.fastq}.sam >> NovoAlignScript.sh;done;cat NovoAlignScript.sh|parallel -j30
for x in *.sam;do echo "samtools view -bS ${x} > ${x%.*}.bam; samtools sort ${x%.*}.bam ${x%.*}_sorted; samtools index ${x%.*}_sorted.bam;samtools idxstats ${x%.*}_sorted.bam > ${x%.*}.idxstats.txt" >> SAM2BAM.sh;done;cat SAM2BAM.sh|parallel -j10
for x in 150424Tho_D15_*.txt;do head -n -1 $x|cut -f3 > ${x}.temp;done;head -n -1 $x|cut -f1 > Name.temp;paste Name.temp 150*.temp > AbsoluteCount.tab
