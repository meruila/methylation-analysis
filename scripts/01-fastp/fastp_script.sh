#! /bin/bash
# #!: shebang - anything that follows this tells us the interpreter of the program (Bash) 

# resource allocation?

# change location of reads and executable fastp here
# change this to location in server. pwd to check
READS_LOCATION="/home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples"
# i think this is hpc pgcbioinfo/fastp
FASTP_LOCATION="/home/smile/Documents/00_UPLB/2021_M/Tools"
EXT=".fq"         #filename extension of input reads
R1_ID="_1"              #identifier for read1
R2_ID="_2"              #identifier for read2
OUTPUT_EXT=".cleaned"   #filename extension of output
# calling of variables is done by prefixing with a dollar sign ($)

mkdir -p ./{html,json,output_files} # creates three folders inside the working directory
# Note: the working directory is where fastp_script.sh is located, indicated by a dot (.)

for rds in $(ls $READS_LOCATION/*$R1_ID$EXT)
do
  FILE_W_EXT=${rds#$READS_LOCATION/}
  FILENAME=${FILE_W_EXT%$R1_ID$EXT}
  in1=$rds
  in2=$READS_LOCATION/$FILENAME$R2_ID$EXT
  out1=./output_files/$FILENAME$R1_ID$OUTPUT_EXT
  out2=./output_files/$FILENAME$R2_ID$OUTPUT_EXT
  result=./html/$FILENAME.html
  result_json=./json/$FILENAME.json
  #from paper: quality scores less than 30 and reads shorter than 50 bases were eliminated
  $FASTP_LOCATION/fastp --qualified_quality_phred 30 --length_required 50 --in1 $in1 --in2 $in2 --out1 $out1 --out2 $out2 --html $result --json $result_json
done

# SAMPLE RUN
# It's okay not to read this part if you're already familiar with bash!
# But here's a sample run just in case you need to understand why some things were done.
# We'll try to run through the program line by line. Suppose we have the following inputs:
# Reads A1: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121770_1.fastq.gz
# Reads A2: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121770_2.fastq.gz
# Reads B1: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121771_1.fastq.gz
# Reads B2: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121771_2.fastq.gz

# for rds in $(ls $READS_LOCATION/*$R1_ID$EXT)
#   - this retrieves all files that are in the READS_LOCATION directory and are suffixed with "_1.fastq.gz"
#   - asterisk (*) stands for any string of characters. In this example, that would be SRR2121770 and SRR2121771
#   - files retrieved:
#         - Reads A1: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121770_1.fastq.gz
#         - Reads B1: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121771_1.fastq.gz
#   - because there are 2 files retrieved, we have 2 iterations of this for loop

# do
#   - for loops in bash scripting start with this keyword

# FILE_W_EXT=${rds#$READS_LOCATION/}
#   - removes READS_LOCATION + "/"
#   - this was done using the # symbol which removes the substring prefixing rds
#   - results of FILE_W_EXT:
#         - Iteration 1 (Reads A1): SRR2121770_1.fastq.gz
#         - Iteration 2 (Reads B1): SRR2121771_1.fastq.gz

# FILENAME=${FILE_W_EXT%$R1_ID$EXT}
#   - removes the identifer for read1 and its file extension ("_1" + ".fastq.gz")
#   - this was done using the % symbol which removes the substring suffixing rds
#   - results of FILENAME:
#         - Iteration 1 (Reads A1): SRR2121770
#         - Iteration 2 (Reads B1): SRR2121771    

# in1=$rds
#   - assigning the value of rds to in1
#   - in1 now contains:
#         - Iteration 1 (Reads A1): /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121770_1.fastq.gz
#         - Iteration 2 (Reads B1): /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121771_1.fastq.gz

# in2=$READS_LOCATION/$FILENAME$R2_ID$EXT
#   - in2 is assigned with this:
#         - "/home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples" + FILENAME + "_2" + ".fastq.gz"
#   - in2 now contains:
#         - Iteration 1 (Reads A2): /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121770_2.fastq.gz
#         - Iteration 2 (Reads B2): /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121771_2.fastq.gz

# *** For out1 onwards, note that the . means the working directory, this is usually where fastp_script.sh is placed ***
# out1=./output_files/$FILENAME$R1_ID$OUTPUT_EXT
#   - out1 is assigned with this:
#         - "./output_files/" + FILENAME + "_1" + ".cleaned"
#   - out1 now contains:
#         - Iteration 1 (Output A1): ./output_files/SRR2121770_1.cleaned
#         - Iteration 2 (Output B1): ./output_files/SRR2121771_1.cleaned

# out2=./output_files/$FILENAME$R2_ID$OUTPUT_EXT
#   - out2 is assigned with this:
#         - "./output_files/" + FILENAME + "_2" + ".cleaned"
#   - out2 now contains:
#         - Iteration 1 (Output A1): ./output_files/SRR2121770_2.cleaned
#         - Iteration 2 (Output B1): ./output_files/SRR2121771_2.cleaned

# result=./html/$FILENAME.html
#   - contains the HTML file produced by fastp
#   - ito yung titignan kapag iccheck na yung graphs
#   - result contains:
#         - Iteration 1 (HTML file 1): ./html/SRR2121770.html
#         - Iteration 2 (HTML file 2): ./html/SRR2121771.html
#   - to open, files are located under <fastp_script.sh location>/html 

# result_json=./json/$FILENAME.json
#   - JSON file produced by fastp
#   - result_json contains:
#         - Iteration 1 (JSON file 1): ./json/SRR2121770.json
#         - Iteration 2 (JSON file 2): ./json/SRR2121771.json

# $FASTP_LOCATION/fastp --in1 $in1 --in2 $in2 --out1 $out1 --out2 $out2 --html $result --json $result_json
#   - this is the line where we call fastp to clean and filter the reads
#   - Iteration 1:
#         - in1: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121770_1.fastq.gz
#         - in2: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121770_2.fastq.gz
#         - out1: ./output_files/SRR2121770_1.cleaned
#         - out2: ./output_files/SRR2121770_2.cleaned
#         - html: ./html/SRR2121770.html
#         - json: ./json/SRR2121770.json
#   - Iteration 2:
#         - in1: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121771_1.fastq.gz
#         - in2: /home/smile/Documents/00_UPLB/2021_M/Datasets/Fastp_samples/SRR2121771_2.fastq.gz
#         - out1: ./output_files/SRR2121771_1.cleaned
#         - out2: ./output_files/SRR2121771_2.cleaned
#         - html: ./html/SRR2121771.html
#         - json: ./json/SRR2121771.json

# done
#   - end for loops with this keyword!
