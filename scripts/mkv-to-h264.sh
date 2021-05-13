#!/bin/bash
mkdir h264
for file in ./*.mkv
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./h264/"${file_name%.*}".mkv"
    echo "Converting file: $original_name to $result_name"
    ffmpeg -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i "$original_name" \
      -vf "scale_npp=-1:720, scale_npp=trunc(iw/2)*2:720" \
      -vcodec h264_nvenc -b:v 5000k -profile:v high \
      -level 4.1 -preset slow -crf 22 \
      -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"
done
