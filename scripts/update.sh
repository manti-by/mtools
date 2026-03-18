#!/bin/bash
CL="\033[0;96m"
NC="\033[0m"

function header () {
    echo -e "${CL}----"
    echo -e "${CL}$1"
    echo -e "----${NC}"
}

header "Update system packages"
sudo apt update
sudo apt upgrade -y

header "Autoremove system packages"
sudo apt clean -y
sudo apt autoremove -y --purge

if [ -d ~/.autoenv/ ]; then
  header "Update autoenv package"
  cd ~/.autoenv/ && git pull
fi

if [ -d ~/.nvm/ ]; then
    header "Install latest NVM version"
    cd ~/.nvm/ && git pull

    header "Install latest Node.js version"
    source ~/.nvm/nvm.sh
    nvm install --lts
fi

if [ -x "$(command -v npm)" ]; then
    header "Update global NPM packages"
    npm update -g --loglevel=error
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
