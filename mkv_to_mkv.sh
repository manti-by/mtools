#!/bin/bash
mkdir mkv
for file in ./*.mkv
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./mkv/"${file_name%.*}".mkv"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i "$original_name" \
      -map 0:v -map 0:a:language:rus \
      -vf "scale_npp=1280:-1, scale_npp=1280:trunc(iw/2)*2" \
      -vcodec h264_nvenc -b:v 3000k -profile:v high \
      -level 4.1 -preset medium \
      -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"
done
