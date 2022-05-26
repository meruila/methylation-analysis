#!/usr/bin/env python3

import csv
import os
import argparse

#summary report

# placeholder values
sampleID = "id"
runFolder = "folder"
refGenome = "genome"
isPairedEnd = "false"

align_summary = "images_summary/01_Bismark Alignment Stats Summary.png"
align_stats = "images_summary/02_Bismark Alignment Stats Numbers.png"
cpg = "images_summary/03_CpG methylation summary.png"
chg = "images_summary/04_CHG methylation summary.png"
chh = "images_summary/05_CHH methylation summary.png"

PREAMBLE = """\\documentclass{article}
\\usepackage[left=1cm, right=1cm, top=1.25cm]{geometry}
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
\\textbf{Bismark Summary Report} 
}
\\end{center}
"""

summary = """\\begin{center}
\\vspace*{10px}
\\begin{tabular}{ |p{4cm} | p{8cm}|}
\\hline
\\textbf{Samples} & """ + str(sampleID) + """ \\\\
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

ALIGNMENT_STATS = """\\section{Alignment Statistics}
\\begin{center}
\\includegraphics[height=1.9in]{""" + str(align_summary) + """} \\\\
{\\small
\\textbf{Figure 1. Alignment statistics by percentages of all reads\\vspace{30px}
} 
}
\\par
\\vspace{30px}
\\includegraphics[height=1.9in]{""" + str(align_stats) + """} \\\\
\\vspace{10px}
{\\small
\\textbf{Figure 2. Alignment statistics by number of reads} 
}
\\end{center}
"""

METHYLATION_STATS = """\\pagebreak
\\section{Cytosine Methylation}
\\begin{center}

\\includegraphics[height=0.95in]{""" + str(cpg) + """} \\\\
{\\small
\\textbf{Figure 3. CpG methylation summary} 
}
\\par
\\vspace{30px}
\\includegraphics[height=0.95in]{""" + str(chg) + """} \\\\
{\\small
\\textbf{Figure 4. CHG methylation summary} 
}
\\par
\\vspace{30px}
\\includegraphics[height=0.95in]{""" + str(chh) + """} \\\\
{\\small
\\textbf{Figure 5. CHH methylation summary} 
}
\\end{center}"""

ENDTEX = """\\end{document}"""

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
  parser = argparse.ArgumentParser(description="Formats Bismark HTML reports to LaTeX format")
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
  texContent = '\n'.join((PREAMBLE, TITLE, summary, ALIGNMENT_STATS, METHYLATION_STATS, ENDTEX))
  saveFile(texContent, o)
  
if __name__ == '__main__':
  main()