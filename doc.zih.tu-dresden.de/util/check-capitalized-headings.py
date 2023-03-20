#!/usr/bin/env python
"""
Check for capitalization of headings.

Author: martin.schroschk@tu-dresden.de
"""

import argparse
from pathlib import Path

whitelist = ["foo", "bar"]


def main(infile):
    with open(infile, "r") as file:
        c = file.readlines()

    incodeblock = False
    for line in c:
        # Remove leading whitespaces
        line = line.strip()

        if line.startswith("```"):
            if incodeblock: incodeblock = False
            else: incodeblock = True

        if incodeblock: continue

        if not line.startswith("#"): continue

        print(line, "\t", line.istitle())

#        for elem in line.split(' ')[1:]:
#            if elem not in whitelist and not elem.istitle():
#                Fehler!


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Find differences in TOC and top level headings of md-files."
    )
    parser.add_argument('-f', '--file', required= True, help = "Specify file to check for capitalized headings")
    args = parser.parse_args()

    main(args.file)
