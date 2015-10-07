date1=$(date +"%s")
echo Creating script for performing adaptor and quality trimming ...
for x in *_R1_001.fastq.gz;do echo bbduk.sh -Xmx20g in1=$x in2=${x%_R1_001.*}_R2_001.fastq.gz ziplevel=9 out1=trimmed\/$x out2=trimmed\/${x%_R1_001.*}_R2_001.fastq.gz minlen=50 qtrim=rl trimq=20 ktrim=r k=25 mink=11 ref=$BBMAP_RESOURCE\/truseq_DNA_HT.fa.gz hdist=1 stats=${x%_R1_001.*}log.txt>> Trim.sh;done;sh Trim.sh
echo Creating script for removing PhiX reads ...
cd trimmed
for x in  *_R1_001.fastq.gz;do echo bbduk.sh -Xmx20g in1=$x in2=${x%_R1_001.*}_R2_001.fastq.gz ziplevel=9 out1=NoPhi\/$x out2=NoPhi\/${x%_R1_001.*}_R2_001.fastq.gz outm1=Phi\/$x outm2=Phi\/${x%_R1_001.*}_R2_001.fastq.gz ref=$BBMAP_RESOURCE\/phix174_ill.ref.fa.gz k=31 hdist=1 stats=${x%_R1_001.*}log.txt>> TrimPhiX.sh;done;sh TrimPhiX.sh
cd NoPhi
for x in *_R1_001.fastq.gz;do echo bbduk.sh -Xmx20g in1=$x in2=${x%_R1_001.*}_R2_001.fastq.gz ziplevel=9 out1=trimPrimerB\/$x out2=trimPrimerB\/${x%_R1_001.*}_R2_001.fastq.gz minlen=50 ktrim=l k=17 literal=GTTTCCCAGTCACGATC hdist=1 stats=${x%_R1_001.*}log.txt>> TrimPrimerB.sh;done;sh TrimPrimerB.sh
#cd trimPrimerB
#echo Creating script for modifying.fastq.gz headers ...
#parallel '/home/martintay/tools/rename.sh {}' ::: *.fastq.gz
#echo Generating fasta files ...
#cd Rename;mkdir Fasta
#parallel 'fq2fa.pl {} > Fasta/{.}.fasta' ::: *.fastq.gz
#echo All done!
#date2=$(date +"%s")
#diff=$(($date2-$date1))
#echo "It took $(($diff / 60)) minutes and $(($diff % 60)) seconds."


