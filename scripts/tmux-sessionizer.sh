#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

last_session_file="/root/.tmux/last_session"
target="$(find "/root/projects/common" "/root/projects/personal" "/root/projects/ip812" "/root/projects/avalon" "/root/projects/work" -mindepth 1 -maxdepth 1 -type d | fzf)"
if [[ -z $"{target}" ]]; then
    exit 0
fi

curr_session="$(realpath "${target}" | cut -d '/' -f6- | tr '.' '_')"

tmux_running="$(pgrep tmux)"
if [[ -z "$TMUX" ]] && [[ -z "${tmux_running}" ]]; then
    tmux new-session -s "${curr_session}" -c "${target}" "vim ${target}"
    tmux new-window -t "${curr_session}:2" -c "${target}"
    tmux select-window -t "${curr_session}:1"
fi

if ! tmux has-session -t="${curr_session}" 2> /dev/null; then
    tmux new-session -ds "${curr_session}" -c "${target}" "vim ${target}"
    tmux new-window -t "${curr_session}:2" -c "${target}"
    tmux select-window -t "${curr_session}:1"
else
    last_session="$(tmux display-message -p '#S')"
    echo "${last_session}" > "${last_session_file}"
fi

tmux switch-client -t "${curr_session}"
