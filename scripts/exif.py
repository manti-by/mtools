#!/usr/bin/python

import time
import exifread
from os import walk, mkdir
from os.path import isfile, isdir, join, splitext, basename
from datetime import datetime
from shutil import copy


input_path = '/mnt/d/Batumi/Export/'
output_path = '/mnt/d/Batumi/Sony/'

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

            #if fpath.find(output_path) >= 0:
            #    print '.... skipped'
            #    continue

            f = open(fname, 'rb')
            tags = exifread.process_file(f)

            if 'EXIF DateTimeOriginal' not in tags:
                continue

            date = datetime.strptime(str(tags['EXIF DateTimeOriginal']), '%Y:%m:%d %H:%M:%S')
            #dirname = join(output_path, date.date().__format__('%Y-%m-%d'))

            counter = 0
            oname = join(output_path, '%s-%02d%s' % (date.__format__('%Y-%m-%d_%H-%M-%S'), counter, fext.lower()))
            while isfile(oname):
                counter += 1
                oname = join(output_path, '%s-%02d%s' % (date.__format__('%Y-%m-%d_%H-%M-%S'), counter, fext.lower()))

            #if not isdir(dirname):
            #    mkdir(dirname)

            copy(fname, oname)
            time.sleep(1)
            print '.... copied'
        except Exception as e:
            print '.... %s' % e
