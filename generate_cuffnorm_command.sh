#!/bin/bash

dir=$PWD
cuffdir=$dir/cuffnorm
annotation=$dir/genome/annotation/annotation.gtf
metadata=$dir/fastq/metadata.tsv

nThreads=12
libtype=fr-firststrand

bamfiles=""
labels=""

mkdir -p $cuffdir

awk '{print $2}' $metadata | sort | uniq | { while read sample
do
label=`echo $sample | awk '{split ($0,a,"_"); print a[2]}'`
bamfile=$dir/STAR/${sample}/Aligned.sortedByCoord.out.bam
bamfiles="$bamfiles $bamfile"
labels="$labels,$label"
done

cd $cuffdir
echo "
cuffnorm  --output-dir $cuffdir --labels ${labels:1:${#labels}-1} --num-threads nThreads --library-type $libtype --library-norm-method geometric $annotation $bamfiles
" > launch_cuffnorm.sh; }

#qsub -l nodes=1:ppn=16 -N cuffnorm launch_cuffnorm.sh
