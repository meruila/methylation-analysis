#! /bin/bash

##--Resource Allocation--##
#SBATCH --job-name=S44-03-deduplicate
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=12G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

#$1 bam file. try test5

hpc pgcbioinfo/bismark:0.23.1 deduplicate_bismark --bam $1
