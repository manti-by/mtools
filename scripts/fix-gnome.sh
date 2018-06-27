#!/bin/bash
echo "Update system settings"
gsettings set org.gnome.desktop.session idle-delay 900
gsettings set org.gnome.gnome-screenshot auto-save-directory file:///home/manti/download/screenshots/

echo "Update nautilus settings"
gsettings set org.gnome.nautilus.preferences default-sort-order type
gsettings set org.gtk.Settings.FileChooser show-hidden false
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

echo "Update gedit settings"
gsettings set org.gnome.gedit.preferences.editor auto-save true
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor display-right-margin true
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
gsettings set org.gnome.gedit.preferences.editor tabs-size 4

echo "Update keyboard settings"
setxkbmap -option 
setxkbmap -layout 'us,ru' -option 'grp_led:scroll'

