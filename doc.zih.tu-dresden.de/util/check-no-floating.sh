#!/bin/bash
scriptpath=${BASH_SOURCE[0]}
basedir=$(dirname "${scriptpath}")
basedir=$(dirname "${basedir}")
DOCUMENT_ROOT=${basedir}/docs
expectedFooter="legal_notice.md accessibility.md data_protection_declaration.md"

MSG=$(find ${DOCUMENT_ROOT} -name "*.md" | while IFS=' ' read string
  do
    md=${string#${DOCUMENT_ROOT}/}

    # md included in nav 
    if [[ ! "${expectedFooter}" =~ ${md} ]]; then
      numberOfReferences=$(sed -n '/nav:/,/^$/p' ${basedir}/mkdocs.yml | grep -c ${md})
      if [[ ${numberOfReferences} -eq 0 ]]; then
        echo "${md} is not included in nav"
      fi
    fi
  done
)
if [[ ! -z "${MSG}" ]]; then
  echo "${MSG}"
  exit 1
fi
