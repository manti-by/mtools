#!/bin/bash
find . -maxdepth 1 -iname "*.jpg" | xargs -i convert -resize 1920x1920 -quality 85 "{}" resized/"{}"