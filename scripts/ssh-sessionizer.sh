#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(echo "sym-VM-eba7723976c1" | tr ' ' '\n' | fzf)"
if [[ -z "${target}" ]]; then
  exit 1
fi

type="$(echo "default tmux" | tr ' ' '\n' | fzf --tac)"
if [[ -z "${type}" ]]; then
  exit 1
fi

case "${target}" in
  "sym-VM-eba7723976c1")
    if [[ "${type}" == "default" ]]; then
      ssh digital@192.168.0.242
    elif [[ "${type}" == "tmux" ]]; then
      ssh digital@192.168.0.242 -t 'tmux attach-session -t default || tmux new-session -s default'
    fi
    ;;
  *)
    echo "Something went wrong" >&2
    ;;
esac
