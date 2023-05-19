#!/bin/bash
scriptpath=${BASH_SOURCE[0]}
basedir=$(dirname "${scriptpath}")
basedir=$(dirname "${basedir}")
DOCUMENT_ROOT=${basedir}/docs

MSG=$(find ${DOCUMENT_ROOT} -name "*.md" | while IFS=' ' read string
  do
    md=${string#${DOCUMENT_ROOT}/}

    # count occurences of md in nav 
    numberOfReferences=$(sed -n '/nav:/,/^$/p' ${basedir}/mkdocs.yml | grep -c ${md})
    if [[ ${numberOfReferences} -gt 1 ]]; then
      echo "${md} is included ${numberOfReferences} times in nav"
    fi
  done
)
if [[ ! -z "${MSG}" ]]; then
  echo "${MSG}"
  exit 1
fi
