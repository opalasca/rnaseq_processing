#!/bin/bash

#absolute path to the folder where the analysis is ran
dir=$PWD

#absolute path to the STAR genome index
genomeDir=$dir/genome/genome_index

#metadata file, containing 3 columns: 1)fastq name 2)desired sample/tissue name 3)read (1 or 2 for paired-end reads)
metadata=$dir/fastq/metadata.tsv

#number of threads
nThreads=12

mkdir -p $dir/STAR

awk '{print $2}' $metadata | sort | uniq | while read sample
do 
sampledir=$dir/STAR/$sample
mkdir -p $sampledir
fastqname=`echo $sample | awk -F "_" '{print $1"_mouse_"$2}'`  ### adapt depending on fastq names, desired output sample name and single-end/paired-end reads ###
echo "
read1=$dir/fastq/${fastqname}_1.fastq.gz
read2=$dir/fastq/${fastqname}_2.fastq.gz
STAR --genomeDir $genomeDir --readFilesIn \$read1 \$read2 --readFilesCommand zcat --outFilterType BySJout --outSAMunmapped Within --outSAMtype BAM SortedByCoordinate --outSAMattrIHstart 0 --outFilterIntronMotifs RemoveNoncanonical --runThreadN $nThreads --quantMode TranscriptomeSAM --outWigType bedGraph --outWigStrand Stranded --outFileNamePrefix $sampledir/ 2> STAR.err
" > $sampledir/launch_star.sh
#qsub -l nodes=1:ppn=16 -N star_$sample launch_star.sh
done
