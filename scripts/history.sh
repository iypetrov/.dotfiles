#!/bin/bash

target="$(cat "${HISTFILE}" | awk '!seen[$0]++' | fzf --tac)"

if [[ -z $target ]]; then
    exit 0
fi

echo "${target}" > "/tmp/history"
