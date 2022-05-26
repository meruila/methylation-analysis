#! /bin/bash

##--Resource Allocation-##
#SBATCH --job-name=00-test-reads
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=2G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

# This script downloads sequences from SRA given a text file.
# How to use:
# 1. Run the following command:
#    ./00-wget.sh <.txt_file_of_reads>
#    Example: ./wget 00-get_reads_-_sample.txt
# 2. The .txt file should contain:
#    a. Line 1: directory where the reads will be placed
#    b. Lines 2-onwards: download links of the reads
#    c. See 00-get_reads_-_sample.txt as an example.
# This can also be used for anything else that needs downloading.
# Just follow the same format for the .txt file (directory then working download links).

ARGUMENTS=1
FORCE_EXIT=65

if [ $# -ne "$ARGUMENTS" ] # checking if user only placed one argument
then
  echo "How to use: ./00-wget.sh <.txt_file_of_reads>"
  echo "Example: ./00-wget.sh 00-get_reads_-_sample.txt"
  echo "Read instructions of using this script: cat 00-wget.sh"
  exit $FORCE_EXIT # exits program if invalid command
fi

FILE=$1
DIR=$(head -n +1 $FILE) # NOTE: make sure that the directory exists! Retrieves directory on where to put the reads, found in the first line
READS=$(tail -n +2 $FILE) # retrieves access links of reads, found after the first line

cd "$DIR"
for t in $READS
do
  wget $t
done

# Reference
# bash bc: https://www.tutorialsandyou.com/bash-shell-scripting/bash-bc-18.html