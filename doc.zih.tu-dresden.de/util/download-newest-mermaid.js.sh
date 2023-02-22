#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`
cd $basedir/tud_theme/javascripts
wget https://unpkg.com/mermaid@9.4.0/dist/mermaid.min.js
