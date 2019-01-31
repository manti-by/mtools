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

header "Update snaps"
sudo snap refresh
