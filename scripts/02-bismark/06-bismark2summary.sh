#! /bin/bash

##--Resource Allocation--##
#SBATCH --job-name=06-summary
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

#$1 00-processing_report--01-bismark_patched.txt

# hpc pgcbioinfo/bismark:0.23.1 bismark2report --alignment_report $1

hpc pgcbioinfo/bismark:0.23.1 bismark2summary 
