#!/bin/bash
export FILE=$1
export FORMAT=$2

find . -name "*.cue" -exec sh -c 'exec shnsplit -f "$FILE" -o $FORMAT -t "%n_%p-%t" "${1%.cue}.$FORMAT"' _ {} \;
