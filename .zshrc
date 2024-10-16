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

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

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

# Custom

### common
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


export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DOCUMENTS_DIR="$HOME/Documents"

### go
export PATH=$PATH:/usr/local/go/bin:~/go/bin:~/go/bin/templ

### java
alias mci="mvn clean install"
alias mgen="mvn generate-sources"
alias mresolve="mvn dependency:purge-local-repository -DreResolve=true"
alias sprrun="mvn spring-boot:run -Dspring-boot.run.jvmArguments=\"-Dspring.profiles.active=local -Dserver.port=8080\""

export JAVA_17_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export JAVA_21_HOME=/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home
export MAVEN_HOME=/opt/homebrew/opt/maven  
export JAVA_HOME=$JAVA_21_HOME
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

use_java() {
    case "$1" in
        11)
            export JAVA_HOME=$JAVA_11_HOME
            ;;
        17)
            export JAVA_HOME=$JAVA_17_HOME
            ;;
        21)
            export JAVA_HOME=$JAVA_21_HOME
            ;;
        23)
            export JAVA_HOME=$JAVA_23_HOME
            ;;
        *)
            echo "Usage: use_java {11|17|21|23}"
            return 1
            ;;
    esac

    export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
    java -version
}

### docker
alias d="docker"
alias dls="docker container ls"
alias dps="docker ps -a"
alias dlog="docker logs -f"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
drm() {
  docker stop $(docker ps -aq)
  docker rm -f $(docker ps -aq)
}

### kubectl
alias k8s="kubectl"
export KUBE_EDITOR=vim

### terraform
alias tf="terraform"
alias tffmt="terraform fmt"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply -auto-approve"
alias tfd="terraform destroy -auto-approve"

export PATH="$HOME/.tfenv/bin:$PATH"

### aws
export AWS_DEFAULT_PROFILE=personal

### azure
az_key() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: az_key <secret-name>"
    return 1
  fi

  local secret_name="$1"
  local key_vault_name="kv-k8s-apps-dev"


  az keyvault secret show --name "${secret_name}" --vault-name "${key_vault_name}" --query value -o tsv
}

# Shell integrations
eval "$(zoxide init --cmd cd zsh)"
