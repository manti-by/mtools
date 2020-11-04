#!/bin/sh
dd if=/dev/zero of=zero.file bs=1024
sync ; sleep 60 ; sync
rm zero.file
