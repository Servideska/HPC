#!/usr/bin/env python
#-*- coding: utf-8 -*-


import yaml


"""
    Create issue for every page of the compendium.

    Import issues from csv file in GitLab:
    It must have a header row and at least two columns:
    the first column is the issue title and the second column is the issue description.
    The separator is automatically detected. The maximum file size allowed is 100 MB.
"""

def extract_filename(d):
    l = []
    for j in d:
        for key, value in j.items():
            if isinstance(value, list):
                l += extract_filename(value)
            else:
                l.append(value)
    return l

# Read in
config = yaml.safe_load(open('../mkdocs.yml'))

# Process
l = extract_filename(config['nav'])

# Output
of = "issues.csv"
with open(of, "w") as f:
    f.write("Title, Description\n")
    for i in l:
        if "archive" in i:
            continue
        j = i.split("/")
        t1 = j[0].upper() + " " + j[-1][0:-3]
        f.write(f"{t1}, {i}\n")

print(f"{of}" written)
