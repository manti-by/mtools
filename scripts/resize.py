#!/usr/bin/python

import time
import exifread

from os import walk, mkdir
from os.path import isfile, isdir, join, splitext, basename
from datetime import datetime
from shutil import copy
from PIL import Image

size = 1920, 1440
input_path = '/home/manti/download/cat/tmp/'
output_path = '/home/manti/download/cat/convert/'

print 'Script started'
for root, directories, filenames in walk(input_path):
    print '%d files found' % len(filenames)
    for f in filenames: 
        try:
            fname = join(root, f)
            fpath, fext = splitext(fname)

            print 'checking file %s' % fname

            if not isfile(fname) or fext.lower() != '.jpg':
                print '.... skipped'
                continue

            f = open(fname, 'rb')
            tags = exifread.process_file(f)

            if 'EXIF DateTimeOriginal' not in tags:
                continue

            date = datetime.strptime(str(tags['EXIF DateTimeOriginal']), 
                                     '%Y:%m:%d %H:%M:%S')

            oname = join(output_path, '%s-%02d%s' % 
                        (date.__format__('%Y-%m-%d_%H-%M-%S'), 0, fext.lower()))

            im = Image.open(fname)
            im.thumbnail(size, Image.ANTIALIAS)
            im.save(oname, "JPEG")

            time.sleep(1)
            print '.... resized'
        except Exception as e:
            print '.... %s' % e
