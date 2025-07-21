# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/bash.bashrc)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# User specific aliases and functions

# ssh keys
eval $(keychain --eval --agents ssh id_ed25519_personal id_ed25519_work)

# fzf
__fzf_history__() {
  local command
  command=$(history | awk '{$1=$1; print}' | cut -d ' ' -f 2- | awk '!seen[$0]++' | fzf +s)
  READLINE_LINE="$command"
  READLINE_POINT=${#READLINE_LINE}
}

bind -x '"\C-r": __fzf_history__'

# common
alias ll='ls -la --color'
alias cls='clear'
alias grep="grep --color"
alias logs="tail -f /var/log/syslog"

kill_pids_on_port() {
    port=$1
    while read pid; do
        kill -9 ${pid}
    done < <(lsof -i :${port} | tail -n +2 | tr -s "[:space:]" " " | cut -d ' ' -f 2)
}

# devbox
alias db="devbox"
alias dbs="devbox search"
alias dbsh="devbox shell --config /root/projects/common/dev-config/devbox.json"

# git
alias g="git"
alias gc="git commit -s"
alias gt="git tag"
alias gp="git push"

# networks
alias ips="ip -br a s"
alias nets="netstat -tulpen"

# bat
export BAT_THEME="GitHub"
alias bat="batcat"

# go
export PATH=$PATH:/root/go/bin

# java
alias mci="mvn clean install"
alias mgen="mvn generate-sources"
alias mresolve="mvn dependency:purge-local-repository -DreResolve=true"
alias mdeps="mvn dependency:tree"

mdepi() {
  mvn dependency:tree -Dincludes="$*"
}

# python

# docker
alias d="docker"
alias dls="docker container ls"
alias dps="docker ps -a"
alias dlog="docker logs -f"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias drmv="docker volume rm $(docker volume ls -q)"
alias dive="docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive"
drm() {
  docker stop $(docker ps -aq)
  docker rm -f $(docker ps -aq)
}

# kubectl
alias k="kubectl"
export KUBE_EDITOR=vim

# terraform
alias tf="terraform"
alias tfv="terraform validate"
alias tffmt="terraform fmt"
alias tfi="terraform init"

tfp() {
    aws_profile="$(cat ~/.aws/config | wc -l | xargs)"
    if [[ "${aws_profile}" == "8" ]]; then
        terraform plan
    else
        terraform plan -lock=false -refresh=false
    fi
}

tfa() {
    aws_profile="$(cat ~/.aws/config | wc -l | xargs)"
    if [[ "${aws_profile}" == "8" ]]; then
        terraform apply -auto-approve
    else
        echo "Don't run apply from this account" 
    fi
}

tfd() {
    aws_profile="$(cat ~/.aws/config | wc -l | xargs)"
    if [[ "${aws_profile}" == "8" ]]; then
        terraform destroy -auto-approve
    else
        echo "Don't run delete from this account" 
    fi
}

# aws
export AWS_DEFAULT_PROFILE=personal
