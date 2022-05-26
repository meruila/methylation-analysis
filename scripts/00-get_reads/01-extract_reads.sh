#! /bin/bash

##--Resource Allocation--##
#SBATCH --job-name=01-test-reads
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=2G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

# This script converts SRA data to fastq format.
# How to use:
# 1. Run the following command:
#    ./01-extract_reads.sh <reads_directory>
#    Example: ./01-extract_reads.sh /location/of/reads
# 2. Lines in this code that must not be deleted:
#    a. mkdir -p $READS_LOCATION/paired_reads
#    b. cd $READS_LOCATION/paired_reads
#    c. Why: it's better to create a separate folder for fastq reads instead of having them in the same folder

ARGUMENTS=1
FORCE_EXIT=65

READS_LOCATION=$1

if [ $# -ne "$ARGUMENTS" ] # checking if user only placed one argument
then
  echo "How to use: ./01-extract_reads.sh <reads_directory>"
  echo "Example: ./01-extract_reads.sh /location/of/reads"
  exit $FORCE_EXIT # exits program if invalid command
fi

mkdir -p $READS_LOCATION/paired_reads
cd $READS_LOCATION/paired_reads

for rds in $(ls $READS_LOCATION)
do
  FULL_PATH=$READS_LOCATION/$rds
  if [ ! -d "$FULL_PATH" ]
  then
    echo "$rds"
    hpc inutano/sra-toolkit fasterq-dump "$rds"
  fi
done

# Reference
# bash bc: https://www.tutorialsandyou.com/bash-shell-scripting/bash-bc-18.html
