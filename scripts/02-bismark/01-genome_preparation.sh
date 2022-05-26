#! /bin/bash

##--Resource Allocation--##
#SBATCH --job-name=gene-prep
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=10G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

hpc pgcbioinfo/bismark:0.23.1 bismark_genome_preparation $1
