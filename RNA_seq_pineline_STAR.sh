#!/bin/bash
#$ -cwd
#$ -j y
#$ -l h_vmem=10G
#$ -pe shm 8
#$ -l h_rt=24:00:00
#$ -A projects_goronzy
#$ -m ea
#$ -M jadhav@stanford.edu

#print the time and date
echo Starting: $(date)

#-------------------------------#
#initialize job context         #
#-------------------------------#

module load python
module load fastqc/0.11.2
module load bowtie/2.2.4
module load MACS2/2.1.1
module load java/latest  python samtools/1.3  picard-tools/1.92  preseq/1.0.2 bedtools/2.25.0 r/3.2.2 igvtools/2.3.3  preseq/1.0.2 ngsplot/2.47
module load STAR/2.5.3a
module load subread/1.6.0


source ./conf.txt

echo "Following are the set paths"
echo "Data Dir: ${myDATADIR}"
echo "Genome Dir: ${myGenomeDIR}"
echo "GTF File path: ${myGenomeGTF}"
echo "No. of CPUs to be used: ${N_CPUS}"

## Align and assemble paired-end sequencing reads
cd ${myDATADIR}
STAR --genomeDir $STAR_HG19_GENOME --genomeLoad LoadAndExit
for basename in $(ls JG*.fastq.gz | cut -f1,2 -d '_' | sort | uniq); do
echo $basename
fq1="_R1_001.fastq.gz"
fq2="_R2_001.fastq.gz"
fq1=$basename$fq1
fq2=$basename$fq2
echo "Performing FastQC for $basename"
fastqc $fq1 -o ../fastQC_output
fastqc $fq2 -o ../fastQC_output
echo "Aligning reads from $basename to the reference genome"
STAR \
--genomeDir $STAR_HG19_GENOME \
--sjdbGTFfile ${myGenomeGTF} \
--runThreadN ${N_CPUS} \
--outSAMstrandField intronMotif \
--outFilterIntronMotifs RemoveNoncanonical \
--outFileNamePrefix ../star_output/$basename \
--readFilesIn $fq1 $fq2 \
--readFilesCommand zcat \
--outSAMtype BAM Unsorted \
--outReadsUnmapped Fastx \
--outSAMmode Full

suffix="Aligned.out.bam"
outname="$basename.count.txt"
bam="../star_output/$basename$suffix"
echo "Running counts for ${bam}"
featureCounts \
-T $N_CPUS \
-t exon \
-g gene_id \
-a ${myGenomeGTF} \
-o ../featureCount_output/$outname \
$bam
echo "Finished Counts"
done


#print the time and date again
echo Ending: $(date)
