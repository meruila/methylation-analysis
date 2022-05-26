#! /bin/bash

##--Resource Allocation-##
#SBATCH --job-name=00-test-reads
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=2G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

ARGUMENTS=1
FORCE_EXIT=65

if [ $# -ne "$ARGUMENTS" ] # checking if user only placed one argument
then
  echo "How to use: ./get_reads.sh <.txt_file_of_reads>"
  echo "Example: ./get_reads.sh 00-get_reads_-_sample.txt"
  exit $FORCE_EXIT # exits program if invalid command
fi

FILE=$1
DIR=$(head -n +1 $FILE) # NOTE: To work properly, make sure that the directory exists!

./00-wget.sh $FILE
./01-extract_reads.sh $DIR
