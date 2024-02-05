#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

bind -x '"\C-l":clear'

# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\] \[\033[01;33m\]\$ \[\033[00m\]"

# dirs
export MNT="/mnt/c/Users/ipetrov"
export STUFF="$MNT/stuff"
export COMMON="$STUFF/common"
export WORK="$STUFF/work"
export BPA="$WORK/projects/besudb"
export PERSONAL="$STUFF/personal/projects"


# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~
export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
alias nvim="env -u VIMINIT nvim"
alias v=nvim
alias t=tmux

# ls
alias ls="ls --color=auto"
alias ll="ls -la"
alias la="ls -lathr"

# cd
alias mnt="cd $MNT"
alias stuff="cd $STUFF"
alias common="cd $COMMON"
alias work="cd $WORK"
alias bpa="cd $BPA"
alias personal="cd $PERSONAL"

alias bpa_mda="cd $BPA/master-data-api"
alias bpa_mdfe="cd $BPA/master-data-fe"
alias bpa_test="cd $BPA/bpa-testing"
alias bpa_build="cd $BPA/btp_build_image"
alias bpa_tools="cd $BPA/bpa-dev-tools"

alias api_gateway="cd $PERSONAL/api-gateway"

# git
alias bpa_sec_on="cd $BPA/master-data-api/ && git checkout develop -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java && cd - &> /dev/null"
alias bpa_sec_off="cd $BPA/master-data-api/ && git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java && cd - &> /dev/null"
alias bpa_db_loc="cd $BPA/master-data-api/ && git checkout local -- src/main/resources/application-local.properties && cd - &> /dev/null"
alias bpa_db_test="cd $BPA/master-data-api/ && git checkout test -- src/main/resources/application-local.properties && cd - &> /dev/null"
alias bpa_db_dev="cd $BPA/master-data-api/ && git checkout develop -- src/main/resources/application-local.properties && cd - &> /dev/null"
alias bpa_host_loc="cd $BPA/master-data-fe/ && git checkout local -- BTP_FE/src/environments/environment.ts && cd - &> /dev/null"
alias bpa_host_dev="cd $BPA/master-data-fe/ && git checkout develop -- BTP_FE/src/emvironments/environment.ts && cd - &> /dev/null"

# docker

# bkubectl

# scripts
alias bpa_deploy="bash $HOME/scripts/bpa_deploy.sh"











