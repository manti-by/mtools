Useful shell scripts
====

Installation and removing
----

    $ ./install.sh
    $ ./install.sh remove

Requirements
----

FFmpeg (binary) and python packages - exifread, pillow, sclib. 

Description
----

- **clean-system** - delete docker dangling containers, images and etc, clear caches.

- **git-clean** - delete stale git branches in the current repo.

- **mconvert FROM_FORMAT TO_FORMAT** - convert all files in the current directory from one format ot another. 
Possible (tested) directions are: arw-to-jpg, avi-to-h264, flac-to-mp3, jpg-to-webp, m4a-to-flac, m4a-to-mp3, 
m4v-to-h264, mkv-to-h265, mkv-to-mkv, mkv-to-mp3, mkv-to-mp4, mp3-to-mp3, mp4-to-gif, mp4-to-mp3, wav-to-flac, 
webm-to-mp3, webp-to-jpg, wmv-to-h264.

- **pyclean** - delete recursively python compiled files in the current directory.

- **sort-photo** - move photos in the current directory to separate directories using date when a photo was taken.

- **soundcloud-dl** - soundcloud downloader.

- **split-cue FILE FORMAT** - split a music album using cue file, tested formats are ape and flac.

- **truncate** - truncate log files in the current directory.

- **update** - update, upgrade and clean system packages

- **zero-filesystem** - fill in free space on the current SSD/HDD by zeros.
