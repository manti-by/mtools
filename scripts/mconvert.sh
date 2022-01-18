#!/bin/bash
export FROM_FORMAT=$1
export TO_FORMAT=$2

mkdir "$TO_FORMAT"
for file in ./*."$FROM_FORMAT"
do
  file_name="${file##*/}"
  original_name="./"$file_name
  result_name="./$TO_FORMAT/${file_name%.*}.$TO_FORMAT"

  echo "Converting file: $original_name to $result_name"
  if [ "$FROM_FORMAT" == "arw" ]; then
    dcraw  -c -w "$original_name" | convert - "$result_name"
  else
    if [ "$TO_FORMAT" == "h264" ]; then
      ffmpeg -i "$original_name" \
        -c:v libx265 -b:v 5000k \
        -profile:v high -preset slow -crf 22 -tune film \
        -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"
    elif [ "$TO_FORMAT" == "h265" ]; then
      ffmpeg -i "$original_name" \
        -c:v libx264 -b:v 3500k -level 4.1 \
        -profile:v high -preset slow -crf 22 -tune film \
        -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"
    elif [ "$TO_FORMAT" == "flac" ]; then
      ffmpeg -i "$original_name" -f flac "$result_name"
    elif [ "$TO_FORMAT" == "mp3" ]; then
      ffmpeg -i "$original_name" -ab 320k "$result_name"
    elif [ "$TO_FORMAT" == "gif" ]; then
      ffmpeg -i "$original_name" -gifflags +transdiff "$result_name"
    else
      ffmpeg -i "$original_name" "$result_name"
    fi
  fi
done
