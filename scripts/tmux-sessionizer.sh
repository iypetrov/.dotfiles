#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

prj_dir="/root/projects"

last_session_file="/root/.tmux/last_session"
if [[ ! -f "${last_session_file}" ]]; then
  mkdir -p "$(dirname "${last_session_file}")"
  touch "${last_session_file}"
fi

target="$(find "$prj_dir" -mindepth 2 -maxdepth 2 -type d -print | sed "s|$prj_dir/||" | fzf)"
if [[ -z $"{target}" ]]; then
    exit 0
fi

curr_session="$(echo "${target}" | tr '.' '_')"

tmux_running="$(pgrep tmux)"
if [[ -z "$TMUX" ]] && [[ -z "${tmux_running}" ]]; then
    tmux new-session -s "${curr_session}" -c "${prj_dir}/${target}" "vim ${prj_dir}/${target}"
    tmux new-window -t "${curr_session}:2" -c "${prj_dir}/${target}"
    tmux select-window -t "${curr_session}:1"
fi

if ! tmux has-session -t="${curr_session}" 2> /dev/null; then
    tmux new-session -ds "${curr_session}" -c "${prj_dir}/${target}" "vim ${prj_dir}/${target}"
    tmux new-window -t "${curr_session}:2" -c "${prj_dir}/${target}"
    tmux select-window -t "${curr_session}:1"
else
    last_session="$(tmux display-message -p '#S')"
    echo "${last_session}" > "${last_session_file}"
fi

tmux switch-client -t "${curr_session}"
