#!/bin/bash
for file in ./*.webp
do
    file_name="${file##*/}"   
    original_name="./"$file_name
    result_name="./"${file_name%.*}".jpg"
    echo "Converting file: $original_name to $result_name"
    convert "$original_name" "$result_name"
done
