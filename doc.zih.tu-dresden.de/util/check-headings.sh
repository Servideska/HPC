#!/bin/bash

# TODO: Document and reference to, e.g.,
# https://editorsmanual.com/articles/capitalizing-headings/#title-case-general-rules

#headings=$(grep -n -r --include="*.md" -E "^#+ " $1)
#
#
#echo -e $headings
#
#for heading in $headings; do
#  echo $heading
#done

# check-headings.sh docs
# check-headings.sh file.md
#
# I cannot think of a grep command that filters out lines starting with "# some" that are comments 
# within a code block.
#   can we test each found line with a additional grep command that determines if the the found
#   match is within a code block?
#   Count number of "```" until this line:
#     * if it is even, not in a code block;
#     * if odd: we are in a code block
#   * How to count number of "```" until and after certain line?
#     * After does not matter!
#
#   Output: 50:# comment in a code block1
#   tail -n +1 check-heading-test.md | head -n 50 | grep -c "\`\`\`"
#   --> 3
#

function check_headings () {
  # $1 file
  while read -r line ; do
      echo "Processing $line"

      line_nr=${line%%:*}
      heading=${line##*\#}

      # TODO Current limitations:
      #   - Allow words like "to", "the", "for", etc. to start with lower case
      #   - Allow for all caps words, e.g. SMT
      status="ok"
      for word in ${heading}; do
        if [[ ! "$word" =~ ^[A-Z] ]]; then
           status="bad"
           break
        fi
      done

      if [ "$status" == "bad" ]; then
        ## Check if heading is inside of code block, i.e., it is a comment
        ret=$(tail -n +1 $1 | head -n ${line_nr} | grep -c "\`\`\`")
        if [[ $(( $ret & 1 )) -eq 1 ]]; then
          echo -e "\tfailed, but is probably a comment inside a code block"
        else
          echo -e "\tfailed"
        fi
      fi

      # your code goes here
  done < <(grep --line-number --recursive --include="*.md" -E "^#+ " $1)
}

if [[ $# -ne 1 || ! -f $1 ]]; then
  usage
fi
if [ -f $1 ]; then
  check_headings $1
fi
