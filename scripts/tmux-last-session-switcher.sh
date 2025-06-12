#!/bin/bash

curr_session="$(tmux display-message -p '#S')"
last_session_file="/home/ipetrov/.tmux/last_session"
last_session="$(cat "${last_session_file}")"

tmux switch-client -t "${last_session}"
echo "${curr_session}" > "${last_session_file}"
