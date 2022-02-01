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

curl --verbose --request POST --form "token=$CI_JOB_TOKEN" --form 'title="Regular check of all pages"' --form "description=\"$description\"" --form "labels=Bot" https://gitlab.hrz.tu-chemnitz.de/api/v4/projects/8840/issues
