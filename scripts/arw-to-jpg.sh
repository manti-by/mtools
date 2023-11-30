#!/bin/bash
mkdir jpg
for file in ./*.ARW
do
  file_name="${file##*/}"
  original_name="./"$file_name
  result_name="./jpg/${file_name%.*}.jpg"

  echo "Converting file: $original_name to $result_name"
  dcraw  -c -w "$original_name" | convert - "$result_name"
done
