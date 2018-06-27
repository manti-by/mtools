#!/bin/bash
for file in ./*.mp4
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./"${file_name%.*}".gif"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" -gifflags +transdiff "$result_name"
done
