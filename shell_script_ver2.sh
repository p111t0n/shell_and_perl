#!/bin/bash

# this script creates one file and deletes all files older than 1 min in the current directory

echo "random text" > output.txt
find . -mmin +1 -type f ! -name "$0" -exec rm -fv {} \;
wd=$(pwd) # get current directory
logger "One file created and all files older than 60s deleted from ${wd} directory"

