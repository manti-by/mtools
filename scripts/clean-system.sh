#!/bin/sh
echo "Clean system journal"
sudo journalctl --vacuum-time=1d

echo "Remove stopped docker containers, unused images and networks"
docker system prune --all --force

echo "Remove docker stale volumens"
docker volume ls | awk '$1 == "local" { print $2 }' | xargs --no-run-if-empty docker volume rm

echo "Clear PageCache, dentries and inodes"
sudo sync; sudo echo 3 > /proc/sys/vm/drop_caches

echo "Remove stale snaps"
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done
