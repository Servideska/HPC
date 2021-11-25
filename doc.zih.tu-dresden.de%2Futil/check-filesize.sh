#!/bin/bash

# Credits to https://gitlab.com/NERSC/nersc.gitlab.io/

large_files_present=false

for f in $(git diff main --name-only); do    
    fs=$(wc -c $f | awk '{print $1}')
    if [ $fs -gt 1048576 ]; then
	echo $f 'is over 1M ('$fs' bytes)'
	large_files_present=true
    fi
done

if [ "$large_files_present" == true ]; then
    exit 1
fi
