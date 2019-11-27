#!/bin/bash
mkdir flac
for file in ./*.ape
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./flac/"${file_name%.*}".flac"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" "$result_name"
done
