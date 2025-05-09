#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(find "${XDG_DOCUMENTS_DIR}/projects/common" "${XDG_DOCUMENTS_DIR}/projects/personal" "${XDG_DOCUMENTS_DIR}/projects/ip812" "${XDG_DOCUMENTS_DIR}/projects/avalonpharma" "${XDG_DOCUMENTS_DIR}/projects/avalon" "${XDG_DOCUMENTS_DIR}/projects/work/cpx/gasx" -mindepth 1 -maxdepth 1 -type d | fzf)"
if [[ -z $"{target}" ]]; then
    exit 0
fi

session="$(realpath "${target}" | cut -d '/' -f6- | tr '.' '_')"

tmux_running="$(pgrep tmux)"
if [[ -z "$TMUX" ]] && [[ -z "${tmux_running}" ]]; then
    tmux new-session -s "${session}" -c "${target}" "vim ${target}"
    tmux new-window -t "${session}:2" -c "${target}"
    tmux select-window -t "${session}:1"
fi

if ! tmux has-session -t="${session}" 2> /dev/null; then
    tmux new-session -ds "${session}" -c "${target}" "vim ${target}"
    tmux new-window -t "${session}:2" -c "${target}"
    tmux select-window -t "${session}:1"
fi

tmux switch-client -t "${session}"
