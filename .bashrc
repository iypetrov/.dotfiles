#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

bind -x '"\C-l":clear'

# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~
parse_git_branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\] \[\033[01;33m\]\$ \[\033[00m\]"

# dirs
export MNT="/mnt/c/Users/ipetrov"
export STUFF="$MNT/stuff"
export COMMON="$STUFF/common"
export WORK="$STUFF/work"
export PERSONAL="$STUFF/personal/projects"

# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~
export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
# ls
alias ls="ls --color=auto"
alias ll="ls -la"
alias la="ls -lathr"

# cd
alias mnt="cd $MNT"
alias stuff="cd $STUFF"
alias common="cd $COMMON"
alias work="cd $WORK"
alias personal="cd $PERSONAL"

# curl
alias curl="cmd.exe /C curl"

# git
alias lazygit="sudo lazygit"

# tmux
alias t=tmux
alias tk="pkill -f tmux"

# nvim
alias nvim="env -u VIMINIT nvim"
alias v=nvim

# docker
alias docker="sudo docker"

# kubectl

# scripts
alias ubu="source ~/scripts/ubuntu.sh"
alias ldg="source $COMMON/ledger/payments.sh"

# ~~~~~~~~~~~~~~~ Variables ~~~~~~~~~~~~~~~~~~~~~~~~

# nvim
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
