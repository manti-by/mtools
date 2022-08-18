#!/bin/sh
cat /dev/zero > zero.file
sync ; sleep 60 ; sync
rm zero.file
