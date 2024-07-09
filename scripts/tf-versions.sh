#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
[[ ! $(command -v tfenv) ]] && echo "Error: You need to have tfenv installed" >&2 && return 1

version="$(tfenv list-remote | fzf)"

if [[ -z $version ]]; then
    exit 0
fi

tfenv install "${version}"
tfenv use "${version}"
