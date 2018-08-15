#!/bin/bash
mkdir mp4
for file in ./*.mkv
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./mp4/"${file_name%.*}".mp4"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" -c:v libx264 \
        -map 0:v -map 0:a:language:rus \
        -vf "scale=-1:720, scale=trunc(iw/2)*2:720" \
        -b:v 2500k -profile:v main -level 4.0 \
        -c:a libmp3lame -b:a 128k -cutoff 18000 "$result_name"
done
