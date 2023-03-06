""" #!/usr/bin/env python
Check for consistency between TOC and page headings.
Provide as an command line argument the path to the mkdocs.yml file.

Author: Michael Bommhardt-Richter
"""

import argparse
import sys
from pathlib import Path

# {path/filename.md: [toc_heading, file_heading], ... }
TOCData = dict()

whitelist = ["index.md"]  # ["archive"]


def get_heading_in_file(filename, docs_path):
    # Read until first level one heading is found
    f = Path.joinpath(docs_path, filename)
    with open(f, "r") as file:
        for line in file:
            if line.startswith("#"):
                # TODO Make sure it is really a level one heading!
                # Will be empty if there is more than one "#".
                return line.split("#")[1].strip()


def main():
    scriptpath = Path(__file__).resolve().parent
    mkdocsyaml = Path.joinpath(scriptpath, "../", "mkdocs.yml")
    if Path.exists(mkdocsyaml):

        docs_path = Path.joinpath(scriptpath, "../", "docs")
        with open(mkdocsyaml, "r") as file:
            c = file.readlines()

        for line in c:
            line = line.rstrip()

            # "headline: path/file.md" -> "Headline" = "path/file.md"
            if line.endswith(".md"):
                line = line.split("  - ")[1]
                line = line.split(": ")

                key = line[1]
                file_heading = get_heading_in_file(line[1], docs_path)
                TOCData[line[1]] = [line[0], file_heading]

        # Check TOC vs heading in corresponding md-file
        cnt = 0
        for key, value in TOCData.items():
            if key in whitelist:
                continue
            if value[0] == "Overview":
                continue
            if value[0] != value[1]:
                cnt += 1
                print(f"{key:<40}{value[0]:<30} != {value[1]}")
        sys.exit(cnt)
    else:
        print("Error: Could not find mkdocs.yml file.")
        sys.exit(-1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Find differences in TOC and top level headings of md-files."
    )
    args = parser.parse_args()

    main()
