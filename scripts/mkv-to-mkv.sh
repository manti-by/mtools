#!/bin/bash
mkdir mkv
for file in ./*.mkv
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./mkv/"${file_name%.*}".mkv"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" -c:v libx264 \
        -map 0:v -map 0:a:language:rus \
        -vf "scale=-1:720, scale=trunc(iw/2)*2:720" \
        -b:v 3500k -profile:v high -level 4.1 \
        -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"
done
