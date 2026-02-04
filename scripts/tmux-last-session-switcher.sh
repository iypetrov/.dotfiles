#!/bin/bash

curr_session="$(tmux display-message -p '#S')"
last_session_file="/root/.tmux/last_session"
last_session="$(cat "${last_session_file}")"

if [[ ! -z "${last_session}" ]]; then
    tmux switch-client -t "${last_session}"
fi

echo "${curr_session}" > "${last_session_file}"
