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

# Change these variables if needed.
R1_ID="_1"
R2_ID="_2"
EXT=".fq"

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
  echo "1) ./$(basename $0) -g /path/to/genome/GRCh38 -r path/to/reads"
  echo "2) ./$(basename $0) --genome /path/to/genome/GRCh38 -r path/to/paired/reads -p"
}

# Command to run:
# (sbatch for slurm, ./ for local run. add -p if paired reads)
# sbatch 00-main.sh -g <genome_folder> -r <reads_folder> -p

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
elif [[ -z "$reads" ]]
then
  echo 'Missing mandatory argument: --reads (-r)'
  exit 1 
fi

# comment out any of the steps if completed previously
# ./01-genome_preparation.sh $genome

echo $genome
echo $isPaired

if [ "$isPaired" == "True" ]
then
  for rds in $(ls $reads/*$R1_ID*)
  do
    FILE_W_EXT=${rds#$READS_LOCATION/}
    FILENAME=${FILE_W_EXT%$R1_ID$EXT}
    read1=$rds
    read2=$READS_LOCATION/$FILENAME$R2_ID$EXT
    # Debug here
    # echo "paired $read1"
    # echo "paired $read2"
    ./02-paired_bismark.sh $genome $read1 $read2

    BAM=${FILENAME}_bismark_bt2.bam
    ./03-deduplicate.sh $BAM

    ./04-methylation_extractor.sh $genome $BAM
  done
else
  echo "not paired"
  for rds in $(ls $reads/)
  do
    # Debug here
    # echo $rds 
    read1=$rds
    ./02-bismark.sh $genome $read1

    BAM=${FILENAME}_bismark_bt2.bam
    ./03-deduplicate.sh $BAM

    ./04-methylation_extractor.sh $genome $BAM
  done
fi

./05-bismark2report.sh
./06-bismark2summary.sh
