#!/bin/bash
shopt -s nullglob

for file in ./*.log
do
    sudo truncate -s 0 "${file##*/}"
done
