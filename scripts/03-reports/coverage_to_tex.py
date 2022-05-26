#!/usr/bin/env python3

# v2: 2021-08-25
# 1. removed XXXX-XXXX-XXXX batch number

# References:
# 1. https://github.com/narimiran/tably/blob/master/tably.py
# 2. sample report from Sir King (sampleLatexReport.tex and parser-writer_v9.py)

import csv
import os
import argparse

# placeholder values
sampleID = "id"
sampleName = "name"
runFolder = "folder"
refGenome = "genome"
isPairedEnd = "false"

PREAMBLE = """\\documentclass{article}
\\usepackage[left=2cm, right=2cm, top=1.25cm]{geometry}
\\usepackage{longtable}
\\usepackage{array}
\\usepackage{makecell}
\\usepackage{booktabs}

\\linespread{1.50}

\\begin{document}"""

TITLE = """\\begin{center}
{\\large
\\textbf{Bismark Coverage Report (Template)} 
}
\\end{center}
"""

summary = """\\begin{center}
\\vspace*{10px}
\\begin{tabular}{ |p{4cm} | p{8cm}|}
\\hline
\\textbf{Sample ID} & """ + str(sampleID) + """ \\\\
\\hline
\\textbf{Sample Name} & """ + str(sampleName) + """ \\\\
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

DEFINITIONS = """\\section{Definition of Terms}
\\begin{tabular}{l|l}
\\textbf{Chromosome} & The chromosome name. \\\\
\\hline
\\textbf{Start Position} & The genomic start position. \\\\
\\hline
\\textbf{End Position} & The genomic end position. \\\\
\\hline
\\textbf{\\% Methylation} & The percentage of methylation at that position. \\\\
\\hline
\\textbf{Methylated} & The number of C bases that are methylated.\\\\
\\hline
\\textbf{Unmethylated} & The number of C bases that are unmethylated. \\\\
\\end{tabular}
"""

THEADER = """\\hline
 Chromosome Name & Start Position & End Position & \\% Methylated & Methylated & Unmethylated \\\\
\\hline
\\endhead
"""

START_TABLE = """\section{Coverage Report}
\\begin{center}
\\begin{longtable}{llllll}
""" + THEADER

END_TABLE = """\\bottomrule
\\end{longtable}
\\end{center}"""

ENDTEX = """\\end{document}"""

def formatRow(r):
  """Formats the row passed from createTable() to LaTeX"""
  for char in '#$%&_}{': #LaTeX special characters that need to be prefixed with a backslash
    r = [cell.replace(char, '\\'+char) for cell in r]
  row = ' & '.join(r)
  return """  """ + row + """ \\\\"""

def createTable(bismarkInput):
  """Creates a LaTeX table from a given .bismark.cov file (tab-separated/tsv)."""
  rows = []

  with open(bismarkInput) as cov:
    for row in csv.reader(cov, delimiter='\t'):
      rows.append(formatRow(row))

  content = '\n'.join(rows)
  return content

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
  parser = argparse.ArgumentParser(description="Formats Bismark coverage report in LaTeX")
  parser._optionals.title = 'Arguments'

  parser.add_argument("-r", "--report", dest="report", required=True,
    help="Required: .bismark.cov file (tab-delimited) to be formatted",
    type=lambda x: isValidFile(parser, x)
  )

  parser.add_argument("-o", "--output", dest="output", required=True,
    help="Required: .tex file (LaTeX) that will serve as output",
    type=lambda x: isValidFile(parser, x)
  )
  return parser.parse_args()

def main():
  args = argParse()
  i = args.report # Bismark input file
  o = args.output # .tex file
  # table = createTable("bismark_test_bismark_bt2.bismark.cov")
  table = createTable(i)
  texContent = '\n'.join((PREAMBLE, TITLE, summary, DEFINITIONS, START_TABLE, table, END_TABLE, ENDTEX))
  saveFile(texContent, o)
  
if __name__ == '__main__':
  main()