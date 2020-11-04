#!/bin/bash
mkdir h264
for file in ./*.avi
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./h264/"${file_name%.*}".mp4"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -i "$original_name" \
      -c:v libx264 -b:v 3500k -profile:v high \
      -level 4.1 -preset slow -crf 22 -tune film \
      -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"
done
