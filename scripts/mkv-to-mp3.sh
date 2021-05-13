#!/bin/bash
mkdir mp3
for file in ./*.mkv
do
    file_name="${file##*/}"
    original_name="./"$file_name
    result_name="./mp3/"${file_name%.*}".mp3"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" -ab 192k "$result_name"
done
