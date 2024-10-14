#!/bin/bash

[[ ! $(command -v fzf) ]] && echo "Error: You need to have fzf installed" >&2 && return 1

target="$(find "${XDG_DOCUMENTS_DIR}/projects/common" "${XDG_DOCUMENTS_DIR}/projects/personal" "${XDG_DOCUMENTS_DIR}/projects/work/symmedia/libs" "${XDG_DOCUMENTS_DIR}/projects/work/symmedia/modules" "${XDG_DOCUMENTS_DIR}/projects/work/symmedia/infr" "${XDG_DOCUMENTS_DIR}/projects/work/symmedia/backend" "${XDG_DOCUMENTS_DIR}/projects/work/symmedia/frontend" -mindepth 1 -maxdepth 1 -type d | fzf)"
if [[ -z $"{target}" ]]; then
    exit 0
fi

session="$(basename "${target}" | tr '.' '_')"

tmux_running="$(pgrep tmux)"
if [[ -z "$TMUX" ]] && [[ -z "${tmux_running}" ]]; then
    tmux new-session -s "${session}" -c "${target}"
    exit 1
fi

if ! tmux has-session -t="${session}" 2> /dev/null; then
    tmux new-session -ds "${session}" -c "${target}"
fi

tmux switch-client -t "${session}"
