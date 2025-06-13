# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# Add in snippets

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=25000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Common
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

export XDG_DATA_HOME="$HOME/.local/share"

# Git
alias g="git"

# Networks
alias ips="ip -br a s"
alias nets="netstat -tulpen"

# Bat
export BAT_THEME="GitHub"

# ASDF
echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc

# Go

# Java
alias mci="mvn clean install"
alias mgen="mvn generate-sources"
alias mresolve="mvn dependency:purge-local-repository -DreResolve=true"
alias mdeps="mvn dependency:tree"

mdepi() {
  mvn dependency:tree -Dincludes="$*"
}

# Python

# Docker
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

### Kubectl
alias k="kubectl"
export KUBE_EDITOR=vim

### Terraform
alias tf="terraform"
alias tfv="terraform validate"
alias tffmt="terraform fmt"
alias tfi="terraform init"

tfp() {
    aws_profile="$(cat ~/.aws/config | wc -l | xargs)"
    if [[ "${aws_profile}" == "8" ]]; then
        terraform plan
    else
        terraform plan -lock=false
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

### AWS
export AWS_DEFAULT_PROFILE=personal
