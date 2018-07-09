#!/bin/bash
TARGET=${1:-install}

if [ "$TARGET" == "install" ]; then
    if [ ! -d "/home/${USER}/bin" ]; then
        echo "Creating user bin directory"
        mkdir /home/${USER}/bin
    fi

    echo "Installing scripts"
    for file in scripts/*.sh scripts/*.py
    do
        file_name="${file##*/}"   
        original_name=$(pwd)"/scripts/$file_name"
        result_name="/home/${USER}/bin/${file_name%.*}"
        ln -s $original_name $result_name
        echo "    ${file_name%.*} installed"
        echo "${file_name%.*}" >> install.lock
    done
else
    echo "Removing scripts"
    while read -r file_name
    do
        rm /home/${USER}/bin/$file_name
        echo "    $file_name removed"
    done < install.lock
    truncate -s 0 install.lock
fi
