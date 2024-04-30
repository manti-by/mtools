#!/bin/bash
CL="\033[0;96m"
NC="\033[0m"

function header () {
    echo -e "${CL}----"
    echo -e "${CL}$1"
    echo -e "----${NC}"
}

header "Clean system journal"
sudo journalctl --vacuum-time=1d

header "Delete old logs"
sudo find /var/log/ -name "*.gz" -type f -delete
sudo find /var/log/ -name "*.log.*" -type f -delete

if [ -x "$(command -v docker)" ]; then
    header "Remove stopped docker containers, unused images and networks"
    docker system prune --all --force

    header "Remove docker stale volumes"
    docker volume ls | awk '$1 == "local" { print $2 }' | xargs --no-run-if-empty docker volume rm
fi

if [ -x "$(command -v pyenv)" ]; then
    header "Clean PIP cache"
    for venv in $(pyenv versions --bare --skip-aliases); do
        /home/manti/.pyenv/versions/$venv/bin/pip cache purge
    done
fi

if [ -x "$(command -v npm)" ]; then
    header "Clean NPM cache"
    npm cache clean --force --loglevel=error
fi

if [ -x "$(command -v snap)" ]; then
    header "Remove stale snaps"
    set -eu
    snap list --all | awk '/disabled/{print $1, $3}' |
        while read snapname revision; do
            sudo snap remove "$snapname" --revision="$revision"
        done
fi

if [ -x "$(command -v psql)" ]; then
    header "Drop test databases"
    export PGPASSWORD=pinata
    psql -Atqc "SELECT 'DROP DATABASE ' || quote_ident(datname) || ';' FROM pg_database WHERE datname like 'test_%';" | psql -U pinata -h localhost
fi

