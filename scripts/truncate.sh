#!/bin/bash
for file in ./*.log
do
    truncate -s 0 "${file##*/}"
done
