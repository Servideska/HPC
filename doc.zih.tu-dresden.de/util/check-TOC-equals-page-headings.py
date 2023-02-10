""" 
Check for consistency between TOC and page headings.
Provide as an command line argument the path to the mkdocs.yml file.

Author: Taras Lazariv
"""

import os
import sys
import yaml
import pandas as pd

def list_and_read_files(path):
    "List files in a directory recursively and read the first line of each file"
    files = []
    firstline = []
    for root, _, filenames in os.walk(path):
        for filename in filenames:
            if filename.endswith('.md'):
                files.append(os.path.join(root.split('/')[-1], filename))
                firstline.append(open(os.path.join(root, filename)).readline().strip().replace('# ',''))
    df = pd.DataFrame({'file': files, 'firstline': firstline})
    return df

def main():
    "Main function"
    path = os.getcwd()
    df = list_and_read_files(path)

    nav_section = dict()

    with open(sys.argv[1], 'r') as file:
        for line in file:
            line = line.rstrip()
            if line.endswith('.md'):
                nav_section.update(yaml.safe_load(line)[0])

    nav_df = pd.DataFrame(nav_section.items(), columns=['title', 'file'])
    with pd.option_context('display.max_rows', None):  # more options can be specified also
        complete_nav_df = pd.merge(df, nav_df, on='file', how='outer')
        print(complete_nav_df.loc[~(complete_nav_df['firstline'] == complete_nav_df['title'])])

if __name__ == '__main__':
    main()