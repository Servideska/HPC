#!/usr/bin/env python
#-*- coding: utf-8 -*-
import re
import sys

def escapeSomeSigns(someString):
    return someString.replace("$", "\\$").replace("(", "\\(").replace(")", "\\)").replace("*", "\\*")

fileName = sys.argv[1]
print("FILE: " + fileName)
lines = []
NORMAL_MODE = 0
CODE_MODE = 1
readMode = NORMAL_MODE
pattern = re.compile(r"<[^<>']*>")
with open(fileName) as f:
    lineNumber = 1
    for line in f:
        if "```" in line:
            # toggle read mode if we find a line with ```, so that we know that we are in a code block or not
            readMode = CODE_MODE if readMode == NORMAL_MODE else NORMAL_MODE
        strippedLine = line.strip()
        # We want tuples with lineNumber, the line itself, whether it is a code line, whether it contains a template (e. g. <FILENAME>) and the line again with all templats replaced by '\\S'
        lines.append((lineNumber, strippedLine, readMode, pattern.search(strippedLine) != None, pattern.sub(r"\\S*", escapeSomeSigns(strippedLine))))
        lineNumber += 1
# those tuples with the CODE_MODE as field 2 represent code lines
codeLines = list(filter(lambda line: line[2] == CODE_MODE, lines))
# we take line number, the line and a regular expression from the those code lines which contain a template, call them templatedLines
templatedLines = list(map(lambda line: (line[0], line[1], re.compile(line[4])), filter(lambda line: line[3], codeLines)))
allPatternsFound = True
for templateLine in templatedLines:
    # find code lines which have a higher line number than the templateLine, contain no template themselves and match the pattern of the templateLine
    matchingCodeLines = list(filter(lambda line: (line[0] > templateLine[0]) and (not line[3]) and (templateLine[2].match(line[1]) != None), codeLines))
    if len(matchingCodeLines) == 0:
        allPatternsFound = False
        print("  Example for \"" + templateLine[1] + "\" (Line " + str(templateLine[0]) + ") missing")

if not allPatternsFound:
    sys.exit(1)
