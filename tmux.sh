#!/bin/bash

# tmux new-session -t work_bpa_foo -d -c "$BESUDB/master-data-api" ; tmux neww bash -c "touch ~/didit" ; tmux attach-session -t work_bpa_foo
# tmux new-session -t work_bpa_foo -d -c "$BESUDB/master-data-api" ; tmux neww bash -c "touch ~/didit"
# tmux attach-session -t $(tmux ls | cut -f1 -d":" | fzf)

file_name="$(date +%W_%Y_%X.txt)"

# tmux new-session -t mda -c "$BESUDB/master-data-api" -d
# tmux new-session -t mdf -c "$BESUDB/master-data-fe" -d

session="$(tmux ls | cut -f1 -d":" | fzf)"

if [[ "$session"=="mda" ]]; then
	touch ~/"mda_$file_name"
elif [[ "$session"=="mdf" ]]; then
	touch ~/"mdf_$file_name"
fi

tmux attach-session -t "$session"
