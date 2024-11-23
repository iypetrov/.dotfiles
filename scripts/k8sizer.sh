#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
[[ ! $(command -v kubectx) ]] && echo "Error: You need to have kubectx installed" >&2 && return 1
[[ ! $(command -v k9s) ]] && echo "Error: You need to have k9s installed" >&2 && return 1

target="$(echo "kubectx kubens k9s" | tr ' ' '\n' | fzf)"
if [[ -z "${target}" ]]; then
  exit 1
fi

case "${target}" in
  "kubectx")
    kubectx 
    ;;
  "kubens")
    kubens 
    ;;
  "k9s")
    k9s
    ;;
  *)
    echo "Something went wrong" >&2
    ;;
esac
