#!/bin/bash
for file in ./*.log
do
    sudo truncate -s 0 "${file##*/}"
done
