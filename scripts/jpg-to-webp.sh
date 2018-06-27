#!/bin/bash
for file in ./*.jpg
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./"${file_name%.*}".webp"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" -qscale 90 "$result_name"
done
