#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

bind -x '"\C-l":clear'

# dirs
export MNT="/mnt/c/Users/ipetrov"
export STUFF="$MNT/stuff"
export COMMON="$STUFF/common"
export WORK="$STUFF/work"
export SYMMEDIA="$WORK/projects/symmedia"
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

# clear
alias cls="clear"

# grep
alias grep="grep --color"

# logs
alias logs="tail -f /var/log/syslog"

# git
git_init() {
  repo_name="$(basename $(pwd))"
  git init
  touch README.md
  git add .
  git commit -m "init commit"
  git remote add origin git@github.com:iypetrov/${repo_name}.git
  git push -u origin master
}

# curl
alias curl="cmd.exe /C curl"

# networks 
alias curl="cmd.exe /C curl"
alias ips="ip -br a s"
alias nets="netstat -tulpen"

alias lazygit="sudo lazygit"
#alias git="git --no-verify"

# networks
alias nvim="env -u VIMINIT nvim"
alias nvim="env -u VIMINIT nvim"

# docker
alias d="docker"
alias dls="docker container ls"
alias dps="docker ps -a"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias drm="docker rm -f $(docker ps -aq)"
alias dlog="docker logs -f"

# kubectl
alias k8s="kubectl"
export KUBE_EDITOR=nvim

# terraform
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply -auto-approve"
alias tfd="terraform destroy -auto-approve"

export PATH="$HOME/.tfenv/bin:$PATH"

# aws
export AWS_DEFAULT_PROFILE=sopra

# azure
az_key() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: az_key <secret-name>"
    return 1
  fi

  local secret_name="$1"
  local key_vault_name="kv-k8s-apps-dev"


  az keyvault secret show --name "$secret_name" --vault-name "$key_vault_name" --query value -o tsv
}


# boundary
export BOUNDARY_ADDR="https://boundary.secure-service-hub.com"
complete -C /usr/bin/boundary boundary

# scripts
alias ubu="source ~/scripts/ubuntu.sh"

ssh_dsync() {
  if [[ $# -ne 1 ]]; then
    echo "provide 1 arg" >&2
    exit 1
  fi

  dir="$1"

  if ! [[ -d "${dir}" ]]; then
    echo "arg should be a dir" >&2
    exit 1
  fi

  target="$(echo "sym-VM-eba7723976c1" | tr ' ' '\n' | fzf)"

  if [[ -z "${target}" ]]; then
    echo "No target selected" >&2
    exit 1
  fi

  while true; do
    echo "Reload changes..."
    case "${target}" in
      "sym-VM-eba7723976c1")
        sshpass -p '123' rsync -av --delete "${dir}" digital@192.168.0.242:~/project/ > /dev/null 2>&1
        ;;
      *)
        echo "Unknown target: ${target}" >&2
        ;;
    esac
    sleep 5
  done
}

# ~~~~~~~~~~~~~~~ Variables ~~~~~~~~~~~~~~~~~~~~~~~~
# nvim
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export PATH="$HOME/.cargo/bin:$PATH"

alias tg="TEMPL_EXPERIMENT=rawgo templ generate"

# java
export JAVA_HOME_11=/usr/lib/jvm/java-11-openjdk-amd64
export JAVA_HOME_17=/usr/lib/jvm/java-17-openjdk-amd64
export JAVA_HOME=$JAVA_HOME_17
export MAVEN_HOME=/usr/share/maven
export GRADLE_HOME=/usr/share/gradle
export PATH=$JAVA_HOME/bin:$JAVA_HOME_11/bin:$JAVA_HOME_17/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH

alias grdg="./gradlew clean generateJava"

# startup
tmux > /dev/null 2>&1
eval "$(oh-my-posh init bash --config ~/.poshthemes/theme.omp.json)"
