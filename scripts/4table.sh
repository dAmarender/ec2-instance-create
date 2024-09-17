#!/bin/bash
# Bash script to print the 3 times multiplication table

echo "4 Times Table:"
for i in {1..10}
do
  result=$((4 * i))
  echo "4 x $i = $result"
done
