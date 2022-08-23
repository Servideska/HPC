#!/bin/bash

#-------------------------------------------------------------------------------
# Checks code styling of contents in utility files and markdown files
# 
# Usage:
# $0 [file| -a] 
#-------------------------------------------------------------------------------
# TODO: Indent check for bash
# TODO: Extend the code style check to other programming language

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "${scriptpath}"`
basedir=`dirname "${basedir}"`

usage() {
  cat <<-EOF
usage: $0 [file | -a]
If file is given, checks code styling for the given file. If parameter -a 
(or --all) is given instead of the file, code style check of all the utility
files and all markdown files is done.
EOF
}

if [[ "${1}" == "-h" ]] ||  [[ "${1}" == "--help" ]]; then
  usage
else
  if [[ "${1}" == "-a" ]]; then
    #files=$(git ls-tree --full-tree -r --name-only HEAD ./ | grep -e '\.sh$' -e '\.md')
    files=$(find $basedir | grep -e '\.md$' -e '\.sh$')
  else
    files=$1
  fi
fi

function style_check() {
  local myfile
  myfile=$1
    
  local pattern
  pattern=$2

  local warning
  warning="${3}"
  
  local ext
  ext="${myfile##*.}"
    
  if  [[ "${ext}" == "sh" ]]; then
    # If shell script is provided
    local test_res
    test_res=$(cat $myfile | grep -nP "${pattern}" | wc -l)
    if [[ "${test_res}" -ne "0" ]]; then
      echo -e "[WARNING] ${warning}" #\nThis coding style was not used for following lines:"
      #echo "This coding style was not used for following lines in file $(realpath ${myfile}):"
      cat $myfile | grep -nP "${pattern}"
      echo ""
    fi
  elif [[ "${ext}" == "md" ]]; then
    # If markdown file is provided
    local test_string  
    #if [[ "$(cat $myfile | sed -n '/^```bash$/,/^```$/p' | grep -v '```'; echo $?)" == 0 ]]
    test_string_exit_code=$(cat $myfile | sed -n '/^```bash$/,/^```$/p' | grep -qv '```'; echo $? | tail -1)
    if [[ "${test_string_exit_code}" -ne "1" ]]; then 
      test_string=$(cat $myfile | sed -n '/^```bash$/,/^```$/p' | grep -v '```')
      local test_res
      local test_res_count
      if echo "${test_string}" | grep -qP "${pattern}"; then
        test_res=$(echo "${test_string}" | grep -oP "${pattern}")
        test_res_count=$(echo $test_string | grep -nP "${pattern}" | wc -l)
      else
        test_res_count=0 
      fi
      if [[ "${test_res_count}" -ne "0" ]]; then
        echo -e "[WARNING] ${warning}" # This coding style was not used for following lines:"
        #echo "This coding style was not used for following lines in file $(realpath ${myfile}):"
        grep -no "$(echo "${test_string}" | grep -P "${pattern}")" "${myfile}"      
        echo ""
      fi
    fi
  fi
}

for file in $files; do
  if [[ "${file}" == "$0" ]]; then
    continue
  fi
  echo "Checking for file ${file}"
  # Variable expansion
  # Currently style check not possible for multiline comment
  pattern='.*"[\n\s\w\W]*\$[^\{|^\(]\w*[\n\s\w\W]*"'
  warning="Using \"\${var}\" is recommended over \"\$var\""
  style_check "${file}" "${pattern}" "${warning}"
  
  # Declaration and assignment of local variables
  pattern='local [a-zA-Z_]*=.*'
  warning="Declaration and assignment of local variables should be on different lines."
  style_check "${file}" "${pattern}" "${warning}"
  
  # Line length less than 80char length
  pattern='^.{80}.*$'
  warning="Recommended maximum line length is 80 characters."
  style_check "${file}" "${pattern}" "${warning}"
  
  # do, then in the same line as while, for and if
  pattern='^\s*(while|for|if)[\w\-\%\d\s\$=\[\]\(\)]*[^;]\s*[^do|then]\s*$'
  warning="It is recommended to put '; do' and '; then' on the same line as the 'while', 'for' or 'if'"
  style_check "${file}" "${pattern}" "${warning}"
  
  # using [[..]] over [..]
  pattern='^\s*(if|while|for)\s*\[[^\[].*$'
  warning="It is recommended to use '[[ … ]]' over '[ … ]', 'test' and '/usr/bin/['"
  style_check "${file}" "${pattern}" "${warning}"
  
  # Avoiding 'eval'
  pattern='^[\w\=\"\s\$\(]*eval.*'
  warning="It is not recommended to use eval"
  style_check "${file}" "${pattern}" "${warning}"
  
  # Arithmetic
  pattern='(\$\([^\(]|let|\$\[)\s*(expr|\w)\s*[\d\+\-\*\/\=\%\$]+'
  warning="It is recommended to use '(( … ))' or '\$(( … ))' rather than 'let' or '\$[ … ]' or 'expr'"
  style_check "${file}" "${pattern}" "${warning}"
  
  # Naming conventions
  # Function name
  pattern='^.*[A-Z]+[_a-z]*\s*\(\)\s*\{'
  warning="It is recommended to function names in lower-case, with underscores to separate words"
  style_check "${file}" "${pattern}" "${warning}"
  
  # Constants and Environment Variable Names
  pattern='readonly [^A-Z]*=.*|declare [-a-zA-Z\s]*[^A-Z]*=.*'
  warning="Constants and anything exported to the environment should be capitalized."
  style_check "${file}" "${pattern}" "${warning}"

done
