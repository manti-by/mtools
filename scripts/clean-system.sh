#!/bin/sh
echo "Clean system journal"
sudo journalctl --vacuum-time=1d

echo "Delete old logs"
sudo find /var/log/ -name "*.gz" -type f -delete
sudo find /var/log/ -name "*.log.*" -type f -delete

if [ -x "$(command -v docker)" ]; then
    echo "Remove stopped docker containers, unused images and networks"
    docker system prune --all --force

    echo "Remove docker stale volumes"
    docker volume ls | awk '$1 == "local" { print $2 }' | xargs --no-run-if-empty docker volume rm
fi

if [ -x "$(command -v pyenv)" ]; then
    echo "Clean PIP cache"
    for venv in $(pyenv versions --bare --skip-aliases); do
        /home/manti/.pyenv/versions/$venv/bin/python -m pip cache purge
    done
fi

if [ -x "$(command -v npm)" ]; then
    echo "Clean NPM cache"
    npm cache clean --force --loglevel=error
fi

if [ -x "$(command -v snap)" ]; then
    echo "Remove stale snaps"
    set -eu
    snap list --all | awk '/disabled/{print $1, $3}' |
        while read snapname revision; do
            sudo snap remove "$snapname" --revision="$revision"
        done
fi
