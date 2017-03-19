
threads=12
annotation=genome/annotation/downloaded_annotation.gtf
fasta=genome/genome/downloaded_dna.fa
outdir=genome/genome_index

mkdir -p $outdir
cd $outdir

echo " 
STAR --runMode genomeGenerate --runThreadN $threads --genomeDir $outdir --genomeFastaFiles $fasta --sjdbGTFfile $annotation --sjdbOverhang 100
" > launch_indexing.sh

#qsub -l nodes=1:ppn=16 -N star_indexing launch_indexing.sh
