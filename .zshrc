# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
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
zinit snippet OMZP::colored-man-pages

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

### Common
alias ll='ls -la --color'
alias cls='clear'
alias grep="grep --color"
alias logs="tail -f /var/log/syslog"

git_init() {
  repo_name="$(basename $(pwd))"
  git init
  touch README.md
  git add .
  git commit -m "init commit"
  git remote add origin git@github.com:iypetrov/${repo_name}.git
  git push -u origin master
}

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

  target="$(echo "sym-VM-eba7723976c1 sym-VM-904cc0fa0741" | tr ' ' '\n' | fzf)"

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
      "sym-VM-904cc0fa0741")
        sshpass -p 'digital' rsync -av --delete "${dir}" digital@127.0.0.1:1035:~/project > /dev/null 2>&1
        ;;
      *)
        echo "Unknown target: ${target}" >&2
        ;;
    esac
    sleep 5
  done
}

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DOCUMENTS_DIR="$HOME/Documents"

# Git
alias g="git"

# Networks
alias ips="ip -br a s"
alias nets="netstat -tulpen"

### Go
export PATH=$PATH:/usr/local/go/bin:~/go/bin:~/go/bin/templ

### Java
alias mci="mvn clean install"
alias mgen="mvn generate-sources"
alias mresolve="mvn dependency:purge-local-repository -DreResolve=true"
alias mdeps="mvn dependency:tree"

mdepi() {
  mvn dependency:tree -Dincludes="$*"
}

export JAVA_17_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export JAVA_21_HOME=/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home
export MAVEN_HOME=/opt/homebrew/opt/maven
export GRADLE_HOME=/opt/homebrew/opt/gradle
export JAVA_HOME=$JAVA_21_HOME
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH

### Python
alias python='python3'
alias pip='python3 -m pip'

export PATH="$(brew --prefix python)/libexec/bin:$PATH"
export PATH="$PATH:/Users/ipetrov/.local/bin"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

### Docker
alias d="docker"
alias dls="docker container ls"
alias dps="docker ps -a"
alias dlog="docker logs -f"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias drmv="docker volume rm $(docker volume ls -q)"
drm() {
  docker stop $(docker ps -aq)
  docker rm -f $(docker ps -aq)
}

### Kubectl
alias k="kubectl"

export KUBE_EDITOR=vim

### Terraform
alias tf="terraform"
alias tffmt="terraform fmt"
alias tfi="terraform init"

tfp() {
    aws_profile="$(cat ~/.aws/current_acc)"
    if [[ "${aws_profile}" == "personal" ]]; then
        terraform plan
    else
        terraform plan -lock=false
    fi
}

tfa() {
    aws_profile="$(cat ~/.aws/current_acc)"
    if [[ "${aws_profile}" == "personal" ]]; then
        terraform apply -auto-approve
    else
        echo "Don't run apply from this account" 
    fi
}

tfd() {
    aws_profile="$(cat ~/.aws/current_acc)"
    if [[ "${aws_profile}" == "personal" ]]; then
        terraform destroy -auto-approve
    else
        echo "Don't run delete from this account" 
    fi
}

export PATH="$HOME/.tfenv/bin:$PATH"

### AWS
export AWS_DEFAULT_PROFILE=personal

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ipetrov/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
