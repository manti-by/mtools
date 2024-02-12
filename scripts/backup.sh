#!/bin/bash
BACKUP_PATH=${1:-"/mnt/data/Archive/odin/"}
sudo duplicity full / file://$BACKUP_PATH \
    --exclude=/home/manti/download/ --exclude=/var/lib/postgresql/ \
    --exclude=/var/lib/elasticsearch/ --exclude=/var/lib/docker/ \
    --exclude=/proc/ --exclude=/run/ --exclude=/sys/ --exclude=/dev/ \
    --exclude=/tmp/  --exclude=/mnt/ --exclude=/swapfile --exclude=/swap.img
