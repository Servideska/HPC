#!/bin/bash

set -eo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`

files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/ | grep '\.md$' | grep -v '/archive/' || true)

description=""
for f in $files; do
description="$description- [ ] $f
"
done

curl --request POST --header "PRIVATE-TOKEN: $SCHEDULED_PAGE_CHECK_PAT" --form 'title="Regular check of all pages"' --form "description=\"$description\"" --form "labels=Bot" https://gitlab.hrz.tu-chemnitz.de/api/v4/projects/${CI_PROJECT_ID}/issues
