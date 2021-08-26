#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`
wordlistfile=$(realpath $basedir/wordlist.aspell)

function getNumberOfAspellOutputLines(){
  cat - | aspell -p "$wordlistfile" --ignore 2 -l en_US list --mode=markdown | sort -u | wc -l
}

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
  branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

any_fails=false

source_hash=`git merge-base HEAD "$branch"`
#Remove everything except lines beginning with --- or +++
files=`git diff $source_hash | sed -n 's/^[-+]\{3,3\} //p'`
#echo "$files"
#echo "-------------------------"
#Assume that we have pairs of lines (starting with --- and +++).
while read oldfile; do
  read newfile
  if [ "${newfile: -3}" == ".md" ]; then
    if [[ $newfile == *"accessibility.md"* ||
          $newfile == *"data_protection_declaration.md"* ||
          $newfile == *"legal_notice.md"* ]]; then
      echo "Skip $newfile"
    else
      echo "Check $newfile"
      if [ "$oldfile" == "/dev/null" ]; then
        #Added files should not introduce new spelling mistakes
        previous_count=0
      else
        previous_count=`git show "$source_hash:${oldfile:2}" | getNumberOfAspellOutputLines`
      fi
      if [ "$newfile" == "/dev/null" ]; then
        #Deleted files do not contain any spelling mistakes
        current_count=0
      else
        #Remove the prefix "b/"
        newfile=${newfile:2}
        current_count=`cat "$newfile" | getNumberOfAspellOutputLines`
      fi
      if [ $current_count -gt $previous_count ]; then
        echo "-- File $newfile"
        echo "Change increases spelling mistake count (from $previous_count to $current_count)"
        any_fails=true
      fi
    fi
  fi
done <<< "$files"

if [ "$any_fails" == true ]; then
  exit 1
fi
