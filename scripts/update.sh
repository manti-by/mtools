#!/bin/bash
CL="\033[0;96m"
NC="\033[0m"

function header () {
    echo -e "${CL}$1"
    echo -e "--------${NC}"
}

header "Update system packages"
sudo apt update
sudo apt upgrade -y

header "Autoremove system packages"
sudo apt clean -y 
sudo apt autoremove -y --purge

if [ -x "$(command -v pyenv)" ]; then
    header "Update pyenv pip versions"
    for venv in $(pyenv versions --bare --skip-aliases); do
        /home/manti/.pyenv/versions/$venv/bin/python -m pip install -U pip
    done
fi

if [ -x "$(command -v flatpak)" ]; then
    header "Update flatpacks"
    sudo flatpak update -y

    header "Remove uninstalled flatpacks"
    sudo flatpak uninstall -y --unused
fi

if [ -x "$(command -v snap)" ]; then
    header "Update snaps"
    sudo snap refresh

    header "Remove stale snaps"
    set -eu
    sudo snap list --all | awk '/disabled/{print $1, $3}' |
        while read snapname revision; do
            sudo snap remove "$snapname" --revision="$revision"
        done
fi
