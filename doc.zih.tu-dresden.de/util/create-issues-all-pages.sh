#!/bin/bash

set -eo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`

files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/ | grep '\.md$' | grep -v '/archive/' || true)

description=""
for f in $files; do
  description="$description- [ ] $f\n"
done
echo "SCHEDULED_PAGE_CHECK_PAT=${SCHEDULED_PAGE_CHECK_PAT+x}"
echo "CI_PROJECT_ID=$CI_PROJECT_ID"

curl --verbose --request POST --header "PRIVATE-TOKEN: $SCHEDULED_PAGE_CHECK_PAT" --form 'title="Regular check of all pages"' --form "description=\"$description\"" --form "labels=Bot" https://gitlab.hrz.tu-chemnitz.de/api/v4/projects/${CI_PROJECT_ID}/issues
