#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

bind -x '"\C-l":clear'

export APP_ENV="dev"

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

# curl
alias curl="cmd.exe /C curl"

# git
alias lazygit="sudo lazygit"

# tmux
tmux > /dev/null 2>&1

# nvim
alias nvim="env -u VIMINIT nvim"
alias v=nvim

# docker
alias d="docker"
alias dls="docker container ls"
alias dps="docker ps -a"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dd="docker stop $(docker ps -aq) && docker rm -f $(docker ps -aq)"

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

# boundary
export BOUNDARY_ADDR="https://boundary.secure-service-hub.com"
complete -C /usr/bin/boundary boundary

k8s_conn() {
  ENVIRONMENT="$(echo "dev test perf staging prod tools" | tr ' ' '\n' | fzf)"
  case "$ENVIRONMENT" in
    dev | development)
      TARGET_NAME="K8s API server (Dev)"
      CLUSTER_NAME="k8s-symmedia-apps-dev"
      CLUSTER_SUBSCRIPTION="sym-cloudplatform-dev"
      CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-dev"
      BOUNDARY_TARGET_ID="ttcp_fWLXN1L5z6"
      ;;
    test)
      TARGET_NAME="K8s API server (Test)"
      CLUSTER_NAME="k8s-symmedia-apps-test"
      CLUSTER_SUBSCRIPTION="sym-cloudplatform-test"
      CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-test"
      BOUNDARY_TARGET_ID="ttcp_UtoNmMexqI"
      ;;
    perf | performance)
      TARGET_NAME="K8s API server (Perf)"
      CLUSTER_NAME="k8s-symmedia-apps-perf"
      CLUSTER_SUBSCRIPTION="sym-cloudplatform-performance"
      CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-perf"
      BOUNDARY_TARGET_ID="ttcp_1nO4HOWdHH"
      ;;
    staging)
      TARGET_NAME="K8s API server (Staging)"
      CLUSTER_NAME="k8s-symmedia-apps-staging"
      CLUSTER_SUBSCRIPTION="sym-cloudplatform-dev"
      CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-staging"
      BOUNDARY_TARGET_ID="ttcp_RoBrrLQHG9"
      ;;
    prod | production)
      TARGET_NAME="K8s API server (Prod)"
      CLUSTER_NAME="k8s-symmedia-apps-prod"
      CLUSTER_SUBSCRIPTION="sym-cloudplatform-prod"
      CLUSTER_RESOURCE_GROUP="rg-plat-kubernetes-prod"
      ;;
    tools)
      TARGET_NAME="K8s API server (Tools)"
      CLUSTER_NAME="k8s-tools"
      CLUSTER_SUBSCRIPTION="sym-cloudplatform-common"
      CLUSTER_RESOURCE_GROUP="rg-k8s-tools"
      ;;
    *)
      echo "Usage: ./boundary-k8s-login.sh <dev|test|perf|staging|prod|tools>" >&2
      exit 1
      ;;
  esac

  # Step 2: Get client port from Boundary
  TARGET_ID=$(boundary targets list -recursive -filter '"/item/name" == "'"$TARGET_NAME"'" and "authorize-session" in "/item/authorized_actions" and "/item/scope/type" == "project"' -format json | jq -r 'if .items != null then .items[0].id else empty end')
  [[ -z "$TARGET_ID" ]] && echo "Error: Could not find target \"$TARGET_NAME\"" >&2 && exit 1
  CLIENT_PORT=$(boundary targets read -id "$TARGET_ID" -format json | jq -r '.item.attributes.default_client_port')
  [[ $CLIENT_PORT =~ ^[0-9]+$ ]] || { echo "Error: Could not get client port from target" >&2 && exit 1; }

  # Step 3: Get host address from Boundary
  HOST_SET_ID=$(boundary targets read -id "$TARGET_ID" -format json | jq -r '.item.host_sources[0].id')
  [[ -z "$HOST_SET_ID" ]] && echo "Error: Could not get host set ID from target" >&2 && exit 1
  HOST_ID=$(boundary host-sets read -id "$HOST_SET_ID" -format json | jq -r '.item.host_ids[0]')
  [[ -z "$HOST_ID" ]] && echo "Error: Could not get host ID from host set" >&2 && exit 1
  HOST_ADDRESS=$(boundary hosts read -id "$HOST_ID" -format json | jq -r '.item.attributes.address')
  [[ -z "$HOST_ADDRESS" ]] && echo "Error: Could not get host address from host" >&2 && exit 1

  # Step 4: Get AKS credentials for the target cluster
  # Automatically switches to the correct kubectl context too
  az aks get-credentials --subscription "$CLUSTER_SUBSCRIPTION" --resource-group "$CLUSTER_RESOURCE_GROUP" --name "$CLUSTER_NAME" --overwrite-existing

  # Step 5: Set kubeconfig to use the Boundary tunnel
  kubectl config set "clusters.${CLUSTER_NAME}.server" "https://127.0.0.1:$CLIENT_PORT"
  kubectl config set "clusters.${CLUSTER_NAME}.tls-server-name" "$HOST_ADDRESS"

  # Step 6: Start the Boundary client
  boundary connect -target-id "${BOUNDARY_TARGET_ID}" 
}

# scripts
alias dv="ssh digital@192.168.0.242 -t 'tmux'"
alias ubu="source ~/scripts/ubuntu.sh"
alias ldg="source $COMMON/ledger/payments.sh"

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
