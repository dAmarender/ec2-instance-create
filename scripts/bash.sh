#!/bin/bash
# Bash script to print the 3 times multiplication table

echo "3 Times Table:"
for i in {1..10}
do
  result=$((3 * i))
  echo "3 x $i = $result"
done

