#!/bin/bash
mkdir mp4
for file in ./*.mkv
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./mp4/"${file_name%.*}".mp4"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i "$original_name" \
      -vf "scale=1280:-1, scale=1280:trunc(iw/2)*2" \
      -vcodec h264_nvenc -b:v 3000k -pass 2 -profile:v high \
      -level 4.1 -preset medium \
      -c:a libfdk_aac -b:a 192k -cutoff 18000 "$result_name"
done
