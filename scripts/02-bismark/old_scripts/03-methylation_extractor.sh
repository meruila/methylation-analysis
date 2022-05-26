#! /bin/bash

##--Resource Allocation--##
#SBATCH --job-name=xy-methyl-extract
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=12G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

FILENAME=${2%.fastq}
BAM=${FILENAME}_bismark_bt2.bam

hpc pgcbioinfo/bismark:0.23.1 bismark_methylation_extractor -s --bedGraph --counts \
--buffer_size 10G --cytosine_report \
--genome_folder $1 \
$BAM
