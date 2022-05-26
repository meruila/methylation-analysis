00-get_reads

00-wget_reads.sh
- Downloads reads from SRA
- Output: unprocessed reads found in <directory_here>

01-extract_reads.sh
- uses SRA toolkit to produce two fastq files
- Output: <read_identifier>_1.fastq and <read_identifier>_2.fastq

get_reads.sh
- wrapper script for 00 and 01
