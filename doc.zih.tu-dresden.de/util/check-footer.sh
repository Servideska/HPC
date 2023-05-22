#!/bin/bash
scriptpath=${BASH_SOURCE[0]}
basedir=$(dirname "${scriptpath}")
basedir=$(dirname "${basedir}")
DOCUMENT_ROOT=${basedir}/docs
expectedFooter="\
legal_notice.md \
accessibility.md \
data_protection_declaration.md"

MSG=$(for md in ${expectedFooter}
  do
    # md included in footer 
    numberOfReferencesInFooter=$(sed -n '/footer:/,/^$/p' \
      ${basedir}/mkdocs.yml | grep -c /${md%.md})
    if [[ ${numberOfReferencesInFooter} -eq 0 ]]; then
      echo "${md} is not included in footer"
    elif [[ ${numberOfReferencesInFooter} -ne 1 ]]; then
      echo "${md} is included ${numberOfReferencesInFooter} times in footer"
    fi
  done
)
if [[ ! -z "${MSG}" ]]; then
  echo "${MSG}"
  exit 1
fi
