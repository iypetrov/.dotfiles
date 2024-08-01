#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
[[ ! $(command -v tfenv) ]] && echo "Error: You need to have tfenv installed" >&2 && return 1

target="$(echo "terraform" | tr ' ' '\n' | fzf)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "terraform")
    version="$(tfenv list-remote | fzf)"
    tfenv install "${version}"
    tfenv use "${version}"
    ;;
  *)
    echo "Something went wrong" >&2
    ;;
esac
