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
      result_name="./$TO_FORMAT/${file_name%.*}.mkv"

      ffmpeg -y -i "$original_name" \
        -vf "scale='min(1280,iw)':'min(720,ih)'" \
        -c:v libxh264 -b:v 3500k \
        -profile:v high -preset slow -crf 22 \
        -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"

    elif [ "$TO_FORMAT" == "h264-cuda" ]; then
      result_name="./$TO_FORMAT/${file_name%.*}.mkv"

      ffmpeg -y -vsync 0 -hwaccel cuda -i "$original_name" \
        -vf "scale='min(1280,iw)':'min(720,ih)'" -c:v h264_nvenc -b:v 3500k \
        -profile:v high -preset slow -crf 22 \
        -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"

    elif [ "$TO_FORMAT" == "h265" ]; then
      result_name="./$TO_FORMAT/${file_name%.*}.mkv"

      ffmpeg -y -i "$original_name" \
        -c:v libx265 -b:v 3500k -level 4.1 \
        -profile:v high -preset slow -crf 22 \
        -c:a libfdk_aac -b:a 128k -cutoff 18000 "$result_name"

    elif [ "$TO_FORMAT" == "flac" ]; then
      ffmpeg -y -i "$original_name" -f flac -r:a 48000 "$result_name"

    elif [ "$TO_FORMAT" == "mp3" ]; then
      ffmpeg -y -i "$original_name" -b:a 192k -r:a 44100 "$result_name"

    elif [ "$TO_FORMAT" == "gif" ]; then
      ffmpeg -y -i "$original_name" -gifflags +transdiff "$result_name"

    else
      ffmpeg -y -i "$original_name" "$result_name"
    fi
  fi
done
