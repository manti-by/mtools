#!/bin/bash
mkdir flac
for file in ./*.m4a
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./flac/"${file_name%.*}".flac"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" -f flac "$result_name"
done
