#!/bin/bash
# Bash script to read and display the contents of a file

# Check if a file is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 filename"
  exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
  echo "File not found!"
  exit 1
fi

# Read and display the file content
while IFS= read -r line
do
  echo "$line"
done < "$1"

