#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`

#This is the ruleset. Each rule consists of a message (first line), a tab-separated list of files to skip (second line) and a pattern specification (third line).
#A pattern specification is a tab-separated list of fields:
#The first field represents whether the match should be case-sensitive (s) or insensitive (i).
#The second field represents the pattern that should not be contained in any file that is checked.
#Further fields represent patterns with exceptions.
#For example, the first rule says:
# The pattern \<io\> should not be present in any file (case-insensitive match), except when it appears as ".io".
ruleset="The word \"IO\" should not be used, use \"I/O\" instead.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\<io\>	\.io
\"SLURM\" (only capital letters) should not be used, use \"Slurm\" instead.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
s	\<SLURM\>
\"File system\" should be written as \"filesystem\", except when used as part of a proper name.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	file \+system	HDFS
Use \"ZIH systems\" or \"ZIH system\" instead of \"Taurus\". \"taurus\" is only allowed when used in ssh commands and other very specific situations.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md	doc.zih.tu-dresden.de/docs/archive/phase2_migration.md
i	\<taurus\>	taurus\.hrsk	/taurus	/TAURUS	ssh	^[0-9]\+:Host taurus$
\"HRSKII\" should be avoided, use \"ZIH system\" instead.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\<hrskii\>
The term \"HPC-DA\" should be avoided. Depending on the situation, use \"data analytics\" or similar.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	hpc[ -]\+da\>
\"ATTACHURL\" was a keyword in the old wiki, don't use it.

i	attachurl
Replace \"todo\" with real content.
doc.zih.tu-dresden.de/docs/archive/system_triton.md
i	\<todo\>	<!--.*todo.*-->
Replace variations of \"Coming soon\" with real content.

i	\(\<coming soon\>\|This .* under construction\|posted here\)
Add table column headers.

i	^[ |]*|$
Avoid spaces at end of lines.
doc.zih.tu-dresden.de/docs/accessibility.md
i	[[:space:]]$
When referencing projects, please use p_number_crunch for consistency.

i	\<p_	p_number_crunch
Avoid \`home\`. Use home without backticks instead.

i	\`home\`
Internal links should not contain \"/#\".

i	(.*/#.*)	(http
When referencing partitions, put keyword \"partition\" in front of partition name, e. g. \"partition ml\", not \"ml partition\".
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\(alpha\|ml\|haswell\|romeo\|gpu\|smp\|julia\|hpdlf\|scs5\|dcv\)-\?\(interactive\)\?[^a-z|]*partition
Give hints in the link text. Words such as \"here\" or \"this link\" are meaningless.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\[\s\?\(documentation\|here\|more info\|\(this \)\?\(link\|page\|subsection\)\|slides\?\|manpage\)\s\?\]
Use \"workspace\" instead of \"work space\" or \"work-space\".
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	work[ -]\+space"

function grepExceptions () {
  if [ $# -gt 0 ]; then
    firstPattern=$1
    shift
    grep -v "$firstPattern" | grepExceptions "$@"
  else
    cat -
  fi
}

function checkFile(){
  f=$1
  echo "Check wording in file $f"
  while read message; do
    IFS=$'\t' read -r -a files_to_skip
    skipping=""
    if (printf '%s\n' "${files_to_skip[@]}" | grep -xq $f); then
      skipping=" -- skipping"
    fi
    IFS=$'\t' read -r flags pattern exceptionPatterns
    while IFS=$'\t' read -r -a exceptionPatternsArray; do
      #Prevent patterns from being printed when the script is invoked with default arguments.
      if [ $verbose = true ]; then
        echo "  Pattern: $pattern$skipping"
      fi
      if [ -z "$skipping" ]; then
        grepflag=
        case "$flags" in
          "i")
            grepflag=-i
          ;;
        esac
        if grep -n $grepflag $color "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" ; then
          number_of_matches=`grep -n $grepflag $color "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" | wc -l`
          ((cnt=cnt+$number_of_matches))
          #prevent messages when silent=true, only files, pattern matches and the summary are printed
          if [ $silent = false ]; then
            echo "    $message"
          fi
        fi
      fi
    done <<< $exceptionPatterns
  done <<< $ruleset
}

function usage () {
cat <<EOF
$0 [options]
Search forbidden patterns in markdown files.

Options:
  -a    Search in all markdown files (default: git-changed files)
  -f    Search in a specific markdown file
  -s    Silent mode
  -h    Show help message
  -c    Show git matches in color
  -v    verbose mode
EOF
}

# Options
all_files=false
#if silent=true: avoid printing of messages
silent=false
#if verbose=true: print files first and the pattern that is checked
verbose=false
file=""
color=""
while getopts ":ahsf:cv" option; do
 case $option in
   a)
     all_files=true
     ;;
   f)
     file=$2
     shift
     ;;
   s)
     silent=true
     ;;
   c)
     color=" --color=always "
     ;;
   v)
     verbose=true
     ;;
   h)
     usage
     exit;;
   \?) # Invalid option
     echo "Error: Invalid option."
     usage
     exit;;
 esac
done

branch="origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-preview}"

if [ $all_files = true ]; then
  echo "Search in all markdown files."
  files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/ | grep .md)
elif [[ ! -z $file ]]; then
  files=$file
else
  echo "Search in git-changed files."
  files=`git diff --name-only "$(git merge-base HEAD "$branch")"`
fi

#Prevent files from being printed when the script is invoked with default arguments.
if [ $verbose = true ]; then
echo "... $files ..."
fi
cnt=0
if [[ ! -z $file ]]; then
  checkFile $file
else
  for f in $files; do
    if [ "${f: -3}" == ".md" -a -f "$f" ]; then
      checkFile $f
    fi
  done
fi

echo "" 
case $cnt in
  1)
    echo "Forbidden Patterns: 1 match found"
  ;;
  *)
    echo "Forbidden Patterns: $cnt matches found"
  ;;
esac
if [ $cnt -gt 0 ]; then
  exit 1
fi
