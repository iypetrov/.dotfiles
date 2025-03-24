#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "provide 2 arg"
    exit 1
fi

if ! [[ -f "$1" ]]; then
    echo "1 arg should be a file"
    exit 2
fi
FILE=$1

if ! [[ "$2" =~ [0-9]+ ]]; then
    echo "2 arg should be an int"
    exit 3
fi
LINE=$2

MIN_LINES=1
MAX_LINES=$(wc -l < "$FILE")

START_LINE=$((LINE - 10))
END_LINE=$((LINE + 10))

if [[ $START_LINE -lt $MIN_LINES ]]; then
    START_LINE=$MIN_LINES
fi

if [[ $END_LINE -gt $MAX_LINES ]]; then
    END_LINE=$MAX_LINES
fi

bat --color=always --style=numbers --highlight-line=$LINE --line-range="${START_LINE}:${END_LINE}" "$FILE"
