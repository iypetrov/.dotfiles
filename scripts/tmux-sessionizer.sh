#!/bin/bash

target="$(find "$COMMON" "$PERSONAL" -mindepth 1 -maxdepth 1 -type d)"
target="$(echo "/home/ipetrov/vault $target" | tr ' ' '\n')"
target="$(echo "/home/ipetrov/.dotfiles $target" | tr ' ' '\n')"
target="$(echo "$target" | fzf)"
if [[ -z $target ]]; then
    exit 0
fi

session="$(basename "$target" | tr . _)"

tmux_running=$(pgrep tmux)
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $session -c $target
    exit 0
fi

if ! tmux has-session -t=$session 2> /dev/null; then
    tmux new-session -ds $session -c $target
fi

tmux switch-client -t $session
