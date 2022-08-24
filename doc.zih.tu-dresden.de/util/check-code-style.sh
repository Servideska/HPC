#!/bin/bash

#-------------------------------------------------------------------------------
# Checks code styling used in files. Currently only shell coding style in shell
# scripts and shell code snippets inside markdown files is supported.
#
# Usage: $0 <arg>
# arg:
#     > -a|--all              : Searches through all files with ".md" and ".sh"
#                               endings
#     > -h|--help|-help|help  : Print help message
#     > file                  : Checks coding style of provided file
#     > If no arguments are provided, only the new/git-changed files will be
#       checked
#-------------------------------------------------------------------------------
# TODO: Indent check for bash
# TODO: Extend the code style check to other programming language

set -euo pipefail

# -----------------------------------------------------------------------------
# Functions Start
usage() {
  cat <<-EOF
usage: $0 [file | -a]
If file is given, checks code styling for the given file. If parameter -a
(or --all) is given instead of the file, code style check of all the utility
files and all markdown files is done.
EOF
}

function style_check() {
  local myfile
  myfile=$1

  local pattern
  pattern=$2

  local warning
  warning="${3}"

  local ext
  ext="${myfile##*.}"

  local test_res_count
  if  [[ "${ext}" == "sh" ]]; then
    # If shell script is provided
    test_res_count=$(grep -cP "${pattern}" $myfile || true)
    if [[ "${test_res_count}" -gt "0" ]]; then
      echo -e "[WARNING] ${warning}" #\nThis coding style was not used for following lines:"
      echo "[WARNING] This coding style was not used for following lines in file $(realpath ${myfile}):"
      grep -nP "${pattern}" $myfile
      echo ""
    fi
  elif [[ "${ext}" == "md" ]]; then
    # If markdown file is provided
    # Check if the code snippet exists in the markdown file
    local test_string_exit_code
    test_string_exit_code=$(cat $myfile | sed -n '/^```bash$/,/^```$/p' | grep -qv '```'; echo $? | tail -1)

    if [[ "${test_string_exit_code}" == "0" ]]; then
      # Extracting code snippet within ```bash ... ```
      local test_string
      test_string=$(cat $myfile | sed -n '/^```bash$/,/^```$/p' | grep -v '```')

      # Check the exit code of pattern match
      if echo "${test_string}" | grep -qP "${pattern}"; then
        test_res_count="$(echo "${test_string}" | grep -cnP "${pattern}")"
      else
        local test_res_count
        test_res_count=0
      fi
      if [[ "${test_res_count}" -gt "0" ]]; then
        echo -e "[WARNING] ${warning}" # This coding style was not used for following lines:"
        echo "[WARNING] This coding style was not used for following lines in file $(realpath ${myfile}):"
        grep -no -F "$(echo "${test_string}" | grep -P "${pattern}")" "${myfile}"
        echo ""
      fi
    fi
  fi
}
# -----------------------------------------------------------------------------
# Functions End

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "${scriptpath}"`
basedir=`dirname "${basedir}"`

branch="origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-preview}"

# Options
if [ $# -eq 1 ]; then
  case $1 in
  -h | help | -help | --help)
    usage
    exit
  ;;
  -a | --all)
    echo "Checking in all files."
    files=$(find $basedir -name '*.md' -o -name '*.sh')
    #file_num=$(find $basedir -name '*.md' -o -name '*.sh' | wc -l) #For debugging
  ;;
  *)
    files="$1"
    file_num=1
  ;;
  esac
elif [ $# -eq 0 ]; then
  echo "Search in git-changed files."
  files=`git diff --name-only "$(git merge-base HEAD "$branch")" | grep -e '.md$' -e '.sh$' || true`
  #For debugging
  #file_num=$(git diff --name-only "$(git merge-base HEAD "$branch")" | grep -c -e '.md$' -e '.sh$' || true)
else
  usage
fi

#counter=0                                           #For debugging
for file in $files; do
  # Variable expansion. Currently style check not possible for multiline comment
  pattern='.*"[\n\s\w\W]*\$[^\{|^\(]\w*[\n\s\w\W]*"'
  warning="Using \"\${var}\" is recommended over \"\$var\""
  style_check "${file}" "${pattern}" "${warning}"

  # Declaration and assignment of local variables
  pattern='local [a-zA-Z_]*=.*'
  warning="Declaration and assignment of local variables should be on different lines."
  style_check "${file}" "${pattern}" "${warning}"

  # Line length less than 80char length
  file_ext="${file##*.}"
  if [[ "${file_ext}" == "sh" ]]; then
    #echo "Checking for max line length..."
    pattern='^.{80}.*$'
    warning="Recommended maximum line length is 80 characters."
    style_check "${file}" "${pattern}" "${warning}"
  fi

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
  warning="It is recommended to write function names in lower-case, with underscores to separate words"
  style_check "${file}" "${pattern}" "${warning}"

  # Constants and Environment Variable Names
  pattern='readonly [^A-Z]*=.*|declare [-a-zA-Z\s]*[^A-Z]*=.*'
  warning="Constants and anything exported to the environment should be capitalized."
  style_check "${file}" "${pattern}" "${warning}"
  #((counter=counter+1))                             #For debugging
  #echo -e "Checked ${counter}/${file_num} files\n"  #For debugging
done
#------------------------------------------------------------------------------
# Script End
