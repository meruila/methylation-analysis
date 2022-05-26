#!/usr/bin/env python3

import csv
import os
import argparse

#processing report

# placeholder values
sampleID = "id"
runFolder = "folder"
refGenome = "genome"
isPairedEnd = "false"

align_stats = "images_processing/01-alignment_stats.png"
c_methylation = "images_processing/02-cytosine_methylation.png"
alignment_bisulfite = "images_processing/03-alignment_bisulfite.png"
dedup = "images_processing/04-deduplication.png"
c_after = "images_processing/05-cytosine_after.png"
mbias1 = "images_processing/06-mbias1.png"
mbias2 = "images_processing/07-mbias2.png"

PREAMBLE = """\\documentclass{article}
\\usepackage[left=2cm, right=2cm, top=1.25cm]{geometry}
\\usepackage{longtable}
\\usepackage{array}
\\usepackage{graphicx}
\\usepackage{makecell}
\\usepackage{booktabs}
\\usepackage{boldline}

\\linespread{1.50}

\\begin{document}"""

TITLE = """\\begin{center}
{\\large
\\textbf{Bismark Processing Report} 
}
\\end{center}
"""

summary = """\\begin{center}
\\vspace*{10px}
\\begin{tabular}{ |p{4cm} | p{8cm}|}
\\hline
\\textbf{Sample ID} & """ + str(sampleID) + """ \\\\
\\hline
\\textbf{Run Folder} & """ + str(runFolder) + """ \\\\
\\hline
\\textbf{Reference Genome} & """ + str(refGenome) + """ \\\\
\\hline
\\textbf{Paired End} & """ + str(isPairedEnd) + """ \\\\
\\hline
\\end{tabular}
\\end{center}
"""

ALIGNMENT_STATS = """\\section{Alignment Stats}
\\begin{center}
\\vspace*{-12px}
\\includegraphics[height=2.5in]{""" + str(align_stats) + """} \\\\
\\begin{tabular}{|l|l|}
\\hline
\\textbf{Sequence pairs analyzed in total} & 34255904 \\\\
\\hline
\\textbf{Paired-end alignments with a unique best hit} & 32481014 \\\\
\\hline
\\textbf{Pairs without alignments under any condition} & 1385 \\\\
\\hline
\\textbf{Pairs that did not map uniquely} & 1773505 \\\\
\\hline
\\textbf{Genomic sequence context not extractable (edges of chromosomes)} & 0 \\\\
\\hline
\\end{tabular}
\\end{center}
"""

METHYLATION_STATS = """\\pagebreak
\\section{Cytosine Methylation}
\\begin{center}
\\vspace*{-12px}
\\includegraphics[height=2.5in]{""" + str(c_methylation) + """} \\\\
\\begin{tabular}{|l|l|}
\\hlineB{2.75}
\\textbf{Total C's analysed} & 771899036 \\\\
\\hlineB{2.75}
\\textbf{Methylated C's in CpG context} & 42878888 \\\\
\\hline
\\textbf{Methylated C's in CHG context} & 2229378 \\\\
\\hline
\\textbf{Methylated C's in CHH context} & 5611294 \\\\
\\hline
\\textbf{Methylated C's in Unknown context} & 1781\\\\
\\hlineB{2.75}
\\textbf{Unmethylated C's in CpG context} & 40323331 \\\\
\\hline
\\textbf{Unmethylated C's in CHG context} & 186572497 \\\\
\\hline
\\textbf{Unmethylated C's in CHH context} & 494283648 \\\\
\\hline
\\textbf{Unmethylated C's in Unknown context} & 364151\\\\
\\hlineB{2.75}
\\textbf{Percentage methylation (CpG context)} & 51.5\% \\\\
\\hline
\\textbf{Percentage methylation (CHG context)} & 1.2\% \\\\
\\hline
\\textbf{Percentage methylation (CHH context)} & 1.1\% \\\\
\\hline
\\textbf{Methylated C's in Unknown context} & N/A\%\\\\
\\hlineB{2.75}
\\end{tabular}
\\end{center}"""

ALIGN_BISULFITE = """\\pagebreak
\\section{Alignment to Individual Bisulfite Strands}
\\begin{center}
\\includegraphics[height=2.5in]{""" + str(alignment_bisulfite) + """} \\\\
\\begin{tabular}{|l|l|l|}
\\hline
\\textbf{OT} & 1280872 & original top strand \\\\
\\hline
\\textbf{CTOT} & 0 & complementary to original top strand \\\\
\\hline
\\textbf{CTOB} & 1385 & complementary to original bottom strand \\\\
\\hline
\\textbf{OB} & 1773505 & original bottom strand \\\\
\\hline
\\end{tabular}
\\end{center}"""

DEDUPLICATION = """\\section{Deduplication}
\\begin{center}
\\includegraphics[height=2.5in]{""" + str(dedup) + """} \\\\
{\\small
\\textbf{Duplicated alignments were found at 1624023 different positions.} 
}
\\end{center}
\\begin{center}
\\begin{tabular}{|l|l|}
\\hline
\\textbf{Alignments analysed} & 32481014 \\\\
\\hline
\\textbf{Unique alignments} & 30778107\\\\
\\hline
\\textbf{Duplicates removed} & 1702907 \\\\
\\hline
\\end{tabular}
\\end{center}"""

AFTER_EXTRACTION = """\\pagebreak
\\section{Cytosine Methylation after Extraction}
\\begin{center}
\\includegraphics[height=2.5in]{""" + str(c_after) + """} \\\\
\\begin{tabular}{|l|l|}
\\hlineB{2.75}
\\textbf{Total C's analysed} & 728818685 \\\\
\\hlineB{2.75}
\\textbf{Methylated C's in CpG context} & 40365434 \\\\
\\hline
\\textbf{Methylated C's in CHG context} & 2103572 \\\\
\\hline
\\textbf{Methylated C's in CHH context} & 5299122 \\\\
\\hlineB{2.75}
\\textbf{Unmethylated C's in CpG context} & 38076494 \\\\
\\hline
\\textbf{Unmethylated C's in CHG context} & 176007533 \\\\
\\hline
\\textbf{Unmethylated C's in CHH context} & 466966530 \\\\
\\hlineB{2.75}
\\textbf{Percentage methylation (CpG context)} & 51.5\% \\\\
\\hline
\\textbf{Percentage methylation (CHG context)} & 1.2\% \\\\
\\hline
\\textbf{Percentage methylation (CHH context)} & 1.1\% \\\\
\\hlineB{2.75}
\\end{tabular}
\\end{center}"""

MBIAS_PLOT = """\\pagebreak
\\section{M-Bias Plot}
\\begin{center}
\\includegraphics[height=2.5in]{""" + str(mbias1) + """} \\\\
{\\small
\\textbf{M-Bias Plot of Read 1} 
}\\\\
\\includegraphics[height=2.5in]{""" + str(mbias2) + """} \\\\
{\\small
\\textbf{M-bias plot of read 2} 
}
\\end{center}
"""

ENDTEX = """\\end{document}"""

def formatRow(r):
  """Formats the row passed from createTable() to LaTeX"""
  for char in '#$%&_}{': #LaTeX special characters that need to be prefixed with a backslash
    r = [cell.replace(char, '\\'+char) for cell in r]
  row = ' & '.join(r)
  return """  """ + row + """ \\\\"""

def saveFile(content, output):
  """Saves .bismark.cov files to .tex format
  content: combined LaTeX content
  output: output file (.tex)
  """
  file = open(output, 'w')
  file.write(content)
  file.close

def isValidFile(parser, file):
  """Checks if file exists"""
  if os.path.exists(file):
    return file
  else:
    parser.error("The file %s does not exist!" % file)

def argParse():
  """Parses command line arguments (-x or --xlongform)"""
  parser = argparse.ArgumentParser(description="Formats Bismark HTML reports to PDF")
  parser._optionals.title = 'Arguments'

  parser.add_argument("-r", "--report", dest="report", required=True,
  help="Required: HTML file of summary or processing report",
  type=lambda x: isValidFile(parser, x)
  )

  parser.add_argument("-o", "--output", dest="output", required=True,
  help="Required: filename of .tex output"
  )
  return parser.parse_args()

def main():
  args = argParse()
  i = args.report # Bismark input file
  o = args.output # .tex file
  texContent = '\n'.join((PREAMBLE, TITLE, summary, ALIGNMENT_STATS, METHYLATION_STATS, ALIGN_BISULFITE, DEDUPLICATION, AFTER_EXTRACTION, MBIAS_PLOT, ENDTEX))
  saveFile(texContent, o)
  
if __name__ == '__main__':
  main()