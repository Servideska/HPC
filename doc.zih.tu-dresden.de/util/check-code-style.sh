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

function pattern_matches() {
  local myfile
  myfile=$1

  local pattern
  pattern=$2

  local warning
  warning="${3}"

  local ext
  ext="${myfile##*.}"

  local test_res_count
  test_res_count=0
  if  [[ "${ext}" == "sh" ]]; then
    # If shell script is provided
    if grep -qP "${pattern}" "$myfile"; then
      echo -e "[WARNING] ${warning}"
      echo "[WARNING] This coding style was not used for following lines in file $(realpath "${myfile}"):"
      grep -nP "${pattern}" "$myfile"
      echo ""
      return 0
    fi
  elif [[ "${ext}" == "md" ]]; then
    # If markdown file is provided
    # Check if the code snippet exists in the markdown file
    if sed -n '/^```bash$/,/^```$/p' "$myfile" | grep -qv '```'; then
      # Extracting code snippet within ```bash ... ```
      local test_string
      test_string=$(sed -n '/^```bash$/,/^```$/p' "$myfile" | grep -v '```')

      # Check the exit code of pattern match
      if echo "${test_string}" | grep -qP "${pattern}"; then
        test_res_count="$(echo "${test_string}" | grep -cnP "${pattern}")"
      fi
      if [[ "${test_res_count}" -gt "0" ]]; then
        echo -e "[WARNING] ${warning}"
        echo "[WARNING] This coding style was not used for following lines in file $(realpath "${myfile}"):"
        grep -no -F "$(echo "${test_string}" | grep -P "${pattern}")" "${myfile}"
        echo ""
        return 0
      fi
    fi
  fi
  # Reached here: Return false/non-zero, i.e. no error/match found
  return 1
}
# -----------------------------------------------------------------------------
# Functions End

scriptpath=${BASH_SOURCE[0]}
basedir=$(dirname "${scriptpath}")
basedir=$(dirname "${basedir}")

branch="origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-preview}"

# Options
if [[ $# -eq 1 ]]; then
  case $1 in
  -h | help | -help | --help)
    usage
    exit
  ;;
  -a | --all)
    echo "Checking in all files."
    files=$(find "$basedir" -name '*.md' -o -name '*.sh')
  ;;
  *)
    files="$1"
  ;;
  esac
elif [[ $# -eq 0 ]]; then
  echo "Search in git-changed files."
  files=$(git diff --name-only "$(git merge-base HEAD "$branch")" | grep -e '.md$' -e '.sh$' || true)
else
  usage
fi

any_fails=false

for file in $files; do
  # Skip the check of this current ($0) script.
  if echo "${file}" | grep -qP "check-code-style.sh$"; then
    continue
  fi

  # Variable expansion. Currently style check not possible for multiline comment
  pattern='.*"[\n\s\w\W]*\$[^\{|^\(]\w*[\n\s\w\W]*"'
  warning="Using \"\${var}\" is recommended over \"\$var\""
  if pattern_matches "${file}" "${pattern}" "${warning}"; then
    any_fails=true
  fi

  # Declaration and assignment of local variables
  pattern='local [a-zA-Z_]*=.*'
  warning="Declaration and assignment of local variables should be on different lines."
  if pattern_matches "${file}" "${pattern}" "${warning}"; then
    any_fails=true
  fi

  # Line length less than 80char length
  file_ext="${file##*.}"
  if [[ "${file_ext}" == "sh" ]]; then
    #echo "Checking for max line length..."
    pattern='^.{80}.*$'
    warning="Recommended maximum line length is 80 characters."
    if pattern_matches "${file}" "${pattern}" "${warning}"; then
      any_fails=true
    fi
  fi

  # do, then in the same line as while, for and if
  pattern='^\s*(while|for|if)[\w\-\%\d\s\$=\[\]\(\)]*[^;]\s*[^do|then]\s*$'
  warning="It is recommended to put '; do' and '; then' on the same line as the 'while', 'for' or 'if'"
  if pattern_matches "${file}" "${pattern}" "${warning}"; then
    any_fails=true
  fi

  # using [[..]] over [..]
  pattern='^\s*(if|while|for)\s*\[[^\[].*$'
  warning="It is recommended to use '[[ … ]]' over '[ … ]', 'test' and '/usr/bin/['"
  if pattern_matches "${file}" "${pattern}" "${warning}"; then
    any_fails=true
  fi

  # Avoiding 'eval'
  pattern='^[\w\=\"\s\$\(]*eval.*'
  warning="It is not recommended to use eval"
  if pattern_matches "${file}" "${pattern}" "${warning}"; then
    any_fails=true
  fi

  # Arithmetic
  pattern='(\$\([^\(]|let|\$\[)\s*(expr|\w)\s*[\d\+\-\*\/\=\%\$]+'
  warning="It is recommended to use '(( … ))' or '\$(( … ))' rather than 'let' or '\$[ … ]' or 'expr'"
  if pattern_matches "${file}" "${pattern}" "${warning}"; then
    any_fails=true
  fi

  # Naming conventions
  # Function name
  pattern='^.*[A-Z]+[_a-z]*\s*\(\)\s*\{'
  warning="It is recommended to write function names in lower-case, with underscores to separate words"
  if pattern_matches "${file}" "${pattern}" "${warning}"; then
    any_fails=true
  fi

  # Constants and Environment Variable Names
  pattern='readonly [^A-Z]*=.*|declare [-a-zA-Z\s]*[^A-Z]*=.*'
  warning="Constants and anything exported to the environment should be capitalized."
  if pattern_matches "${file}" "${pattern}" "${warning}"; then
    any_fails=true
  fi
done
if [[ "${any_fails}" == true ]]; then
  exit 1
fi
