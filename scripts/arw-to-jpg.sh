#!/bin/bash
mkdir jpg
out_path="$(pwd)/jpg"
ufraw-batch *.ARW --out-type=jpg --compression=100 --size=1920 --out-path="$out_path"
