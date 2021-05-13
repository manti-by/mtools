#!/bin/sh
cat /dev/null > zero.file
sync ; sleep 60 ; sync
rm zero.file
