#!/bin/bash
## Purpose:
##   Checks internal links for all (git-)changed markdown files (.md) of the repository.

set -eo pipefail

export ENABLED_HTMLPROOFER=true
mkdocs build
