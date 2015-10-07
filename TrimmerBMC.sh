date1=$(date +"%s")
echo Creating script for performing adaptor and quality trimming ...
for x in *_1_sequence.*;do echo bbduk.sh -Xmx1g in1=$x in2=${x%_1_*}_2_sequence.fastq out1=trimmed\/$x out2=trimmed\/${x%_1_*}_2_sequence.fastq minlen=75 qtrim=rl trimq=20 ktrim=r k=25 mink=11 ref=$BBMAP_RESOURCE\/nextera.fa.gz hdist=1 stats=${x%_1_*}log.txt>> Trim.sh;done;sh Trim.sh
echo Creating script for removing PhiX reads ...
cd trimmed
for x in *_1_sequence.*;do echo bbduk.sh -Xmx1g in1=$x in2=${x%_1_*}_2_sequence.fastq out1=NoPhi\/$x out2=NoPhi\/${x%_1_*}_2_sequence.fastq outm1=Phi\/$x outm2=Phi\/${x%_1_*}_2_sequence.fastq ref=$BBMAP_RESOURCE\/phix174_ill.ref.fa.gz k=31 hdist=1 stats=${x%_1_*}log.txt>> TrimPhiX.sh;done;sh TrimPhiX.sh
echo Creating script for modifying fastq headers ...
cd NoPhi
parallel 'rename.sh {}' ::: *.fastq
echo Generating fasta files ...
cd Rename;mkdir Fasta
parallel 'fq2fa.pl {} > Fasta/{.}.fasta' ::: *.fastq
mkdir Interleaved
for x in *_1_sequence.fastq;do reformat.sh -Xmx1g in=$x in2=${x%1_sequence.fastq}2_sequence.fastq out=Interleaved/${x%_1_sequence.fastq}.fastq;done
cd Interleaved;mkdir Derep;mkdir Replicates
for x in *.fastq;do dedupe.sh -Xmx10g in=$x out=Derep/$x outd=Replicates/$x interleaved=t;done
cd Derep;mkdir Pairs
for x in *.fastq;do reformat.sh -Xmx1g in=$x out=Pairs/${x%.fastq}_1_sequence.fastq out2=Pairs/${x%.fastq}_2_sequence.fastq;done
cd ../../
ls *.fastq > temp;ls *.fastq|sed 's/-/_/g' > temp2;paste temp*|sed 's/^/mv /g;s/\t/ /g' > temp3;sh temp3;rm temp*
parallel 'gzip -9 {}' ::: *.fastq
echo All done!
date2=$(date +"%s")
diff=$(($date2-$date1))
echo "It took $(($diff / 60)) minutes and $(($diff % 60)) seconds."


