#!/bin/bash
mkdir mp3
for file in ./*.mp3
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./mp3/"${file_name%.*}".mp3"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" -ab 192k -map_metadata 0 -id3v2_version 3 "$result_name"
done
