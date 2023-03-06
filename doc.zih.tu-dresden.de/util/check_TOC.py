""" #!/usr/bin/env python
Check for consistency between TOC and page headings.
Provide as an command line argument the path to the mkdocs.yml file.

Author: Michael Bommhardt-Richter
"""


import os
import sys
files = []
firstline = []
nav_section = dict()

TOCFiles=dict()
TOCData=dict()

def list_and_read_files(path):
    "List files in a directory recursively and read the first line of each file"

    for root, _, filenames in os.walk(path):
        for filename in filenames:
            if filename.endswith('.md'):
                TOCFiles[os.path.join(root.split('/')[-1], filename)]=open(os.path.join(root, filename)).readline().strip().replace('# ','')
    return 0

def main():
    "Main function"
    path = os.getcwd()

    nav_section = dict()
    with open(sys.argv[1], 'r') as file:
        for line in file:
            line = line.rstrip()
            
            if line.endswith('.md'):
                line=line.split("  - ")[1]
                line=line.split(": ")
                TOCData[line[1]]=line[0]

    set1 = set(TOCFiles.items())
    set2 = set(TOCData.items())
    output=str(sorted(set1 ^ set2))
    output=output.replace("{('","'").replace(")}","").replace("[(","").replace(")]","").split("), (")
    print("|                          Filename                          |                              Diff                          |")
    print("|------------------------------------------------------------|------------------------------------------------------------|")
    
    for x in output:
        if not "overview.md" in x and not "Overview" in x:
            #if not "(Outdated)" in x and not "index.md" in x:
                #print(x)
                y=x.split("', '")
                print("|{0:>60}|{1:>60}".format(y[0]+"'", "'"+y[1]))
     

if __name__ == '__main__':
    if len(sys.argv) > 1:
        main()
    else:
        print("Missing Parameter. Start with 'python3 check_TOC.py mkdocs.yml'")
