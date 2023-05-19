#!/bin/bash
scriptpath=${BASH_SOURCE[0]}
basedir=$(dirname "${scriptpath}")
basedir=$(dirname "${basedir}")
DOCUMENT_ROOT=${basedir}/docs
# there should be at most one directory between the root directory and the page
maxDepth=1
DOCUMENT_SLASH_COUNT=$(echo "${DOCUMENT_ROOT}/" | awk -F'/' '{print NF}')

MSG=$(find ${DOCUMENT_ROOT} -name "*.md" | awk -F'/' '{print $0,NF}' | while IFS=' ' read string slash_count
  do
    depth=$((slash_count - DOCUMENT_SLASH_COUNT))
    if [[ "${depth}" -gt ${maxDepth} ]]; then
      echo "max depth (${maxDepth}) exceeded for ${string}"
    fi
  done
)
if [[ ! -z "${MSG}" ]]; then
  echo "${MSG}"
  exit 1
fi
