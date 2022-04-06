#!/bin/bash

set -eo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
pythonscript="$basedir/check-templated-code-snippets.py"
basedir=`dirname "$basedir"`

function usage() {
  cat <<-EOF
usage: $0 [file | -a]
Search for code snippets that use templates but do not give examples.
If file is given, outputs all lines where no example could be found.
If parameter -a (or --all) is given instead of the file, checks all markdown files.
Otherwise, checks whether any changed file contains code snippets with templates without examples.
EOF
}

branch="origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-preview}"

# Options
if [ $# -eq 1 ]; then
  case $1 in
  help | -help | --help)
    usage
    exit
  ;;
  -a | --all)
    echo "Search in all markdown files."
    files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/ | grep .md)
  ;;
  *)
    files="$1"
  ;;
  esac
elif [ $# -eq 0 ]; then
  echo "Search in git-changed files."
  files=`git diff --name-only "$(git merge-base HEAD "$branch")" | grep .md || true`
else
  usage
fi

all_ok=''
for f in $files; do
if ! $pythonscript $f; then
all_ok='no'
fi
done

if [ -z "$all_ok" ]; then
echo "Success!"
else
echo "Fail!"
exit 1
fi
