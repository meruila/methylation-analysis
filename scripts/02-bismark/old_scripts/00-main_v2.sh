#!/bin/bash

##--Resource Allocation--##
#SBATCH --job-name=20-bispaired
#SBATCH --account=training2021
#SBATCH --qos=shortjobs
#SBATCH --cpus-per-task=8
#SBATCH --mem=20G
#SBATCH --out=%x.out
#SBATCH --err=%x.err

unset genome
unset reads
unset isPaired

isPaired="False"

function usage {
  echo "How to use ./$(basename $0):"
  echo "Mandatory arguments"
  echo "-g or --genome: Specify directory containing genome of interest. 
  Inside the directory, accepted genome formats are fasta files ending with .fa or .fasta"
  echo "-r or --reads: Specify .fastq or .fasta file to be analyzed
  Sequence files must be in the current directory for the examples below to work.
  Otherwise, include the path to the files."
  echo
  echo "Examples:"
  echo "1) ./$(basename $0) -g /path/to/genome/GRCh38 -r test_dataset.fastq"
  echo "2) ./$(basename $0) --genome /path/to/genome/GRCh38 -r test_dataset.fastq"
}

# function usage {
#   echo "How to use ./$(basename $0):"
#   echo "Mandatory arguments"
#   echo "-g or --genome: Specify directory containing genome of interest. 
#   Inside the directory, accepted genome formats are fasta files ending with .fa or .fasta"
#   echo "-r or --reads: Specify directory containing .fastq or .fasta files to be analyzed"
#   echo
#   echo "Examples:"
#   echo "1) ./$(basename $0) -g /path/to/genome/GRCh38 -r path/to/fastq/files"
#   echo "2) ./$(basename $0) --genome /path/to/genome/GRCh38 -r path/to/fastq/files"
# }

# Known error:
# can do -g -r and -h at the same time
while [ "$1" != "" ]; do
  case $1 in
    -g | --genome )
      shift
      genome="$1"
      # echo $genome
      ;;
    -r | --reads )
      shift
      reads="$1"
      ;;
    -p | --paired )
      shift
      isPaired="True"
      ;;
    -h | --help )
      usage
      exit
      ;;
    * )
      echo "Unknown argument: $1"
      exit 1
  esac
  shift
done

if [[ -z "$genome" ]]
then
  echo 'Missing mandatory argument: --genome (-g)' >&2
  exit 1
elif [ "$reads" -eq "True" ] && [ -z "$reads1" || -z "$reads2" ]
then
  echo 'Missing mandatory argument for paired-end reads: --in1 (-1) or --in2 (-2)'
  exit 1 
elif [ "$paired" -eq "False" ] && [ -z "$reads1" ]
then
  echo 'Missing mandatory argument for single-end reads: --in1 (-1)'
  exit 1 
fi

# comment out any of the steps if completed previously
# ./01-genome_preparation.sh $genome

if [[ "$paired" -eq "True" ]]
then
  ./02-paired_bismark.sh $genome $reads1 $reads2
  BAM=${FILENAME}_bismark_bt2.bam
  ./03-deduplicate.sh $BAM
  # ./03-methylation_extractor.sh $genome $reads1 $reads2
else
  echo "not paired"
  # ./02-bismark.sh $genome $reads1
  # ./03-methylation_extractor.sh $genome $reads1
fi

# Command to run: sbatch 00-main.sh --genome /home/users/marguelles/03-ref_genome/XandY --in1 bismark_test.fastq --in2 
