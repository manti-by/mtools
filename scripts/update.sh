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

header "Update flatpacks"
sudo flatpak update -y

header "Remove uninstalled flatpacks"
sudo flatpak uninstall -y --unused

header "Update snaps"
sudo snap refresh

header "Remove stale snaps"
set -eu
sudo snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done
