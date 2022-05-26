#! /bin/bash

##--Resource Allocation--##
#SBATCH --job-name=bismark_main
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=12G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

# ./01-genome_preparation.sh
./02-bismark $1 $2
./03-methylation_extractor.sh *.bam
