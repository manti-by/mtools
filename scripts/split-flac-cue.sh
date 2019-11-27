#!/bin/bash
find . -name "*.cue" -exec sh -c 'exec shnsplit -f "$1" -o flac -t "%n_%p-%t" "${1%.cue}.flac"' _ {} \;
