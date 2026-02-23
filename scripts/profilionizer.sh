#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1
[[ ! $(command -v kubectx) ]] && echo "Error: You need to have kubectx installed" >&2 && return 1

targets="$(echo "kubens kubectx" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${targets}" ]]; then
  exit 1
fi

case "${targets}" in
  "kubens")
    kubens
    ;;
  "kubectx")
    kubectx
    ;;

  *)
    echo "Something went wrong" >&2
    ;;
esac
