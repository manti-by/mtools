#!/bin/bash
echo "Trying to create BIN directory"
mkdir /home/${USER}/bin

echo "Installing scripts"
ln -s $(pwd)/fix_gnome.sh /home/${USER}/bin/fix_gnome
ln -s $(pwd)/flac_to_mp3.sh /home/${USER}/bin/flac_to_mp3
ln -s $(pwd)/mkv_to_mkv.sh /home/${USER}/bin/mkv_to_mkv
ln -s $(pwd)/mkv_to_mp4.sh /home/${USER}/bin/mkv_to_mp4
ln -s $(pwd)/pyclean.sh /home/${USER}/bin/pyclean
ln -s $(pwd)/update.sh /home/${USER}/bin/update
