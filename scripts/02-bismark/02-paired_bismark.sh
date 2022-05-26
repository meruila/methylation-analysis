#! /bin/bash

##--Resource Allocation--##
#SBATCH --job-name=02b-paired
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=12G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

#hpc pgcbioinfo/bismark:0.23.1 bismark $1 $2

hpc pgcbioinfo/bismark:0.23.1 bismark $1 -1 $2 -2 $3
