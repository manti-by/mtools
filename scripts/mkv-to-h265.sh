#!/bin/bash
mkdir h265
for file in ./*.mkv
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./h265/"${file_name%.*}".mkv"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -y -i "$original_name" -c:v libx265 -b:v 5000k -crf 23 \
        -vf "scale=-1:720, scale=trunc(iw/2)*2:720" \
        -profile:v high -preset slow \
        -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"
done
