#!/bin/bash

dotfiles_path="/mnt/c/Users/ipetrov/stuff/common/.dotfiles" 

dos2unix "$dotfiles_path/.bashrc"
dos2unix "$dotfiles_path/.tmux.conf"

source ~/.bashrc
tmux source ~/.tmux.conf

find "$dotfiles_path/scripts" -type f -exec dos2unix {} \;
