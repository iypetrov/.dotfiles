#!/bin/bash

sudo apt-get update && sudo apt-get upgrade

opath="$(pwd)"

cd "$HOME"
mkdir -p .config/vim
mkdir -p .config/nvim

cd "$opath"
ln -sf "$PWD/.bashrc" "$HOME"/.bashrc
ln -sf "$PWD/.gitconfig" "$HOME"/.gitconfig
ln -sf "$PWD/.gitconfig-personal" "$HOME"/.gitconfig-presonal
ln -sf "$PWD/.gitconfig-work" "$HOME"/.gitconfig-work
ln -sf "$PWD/.tmux.conf" "$HOME"/.tmux.conf
ln -sf "$PWD/.ssh" "$HOME"/.ssh
ln -sf "$PWD/scripts" "$HOME"/scripts
ln -sf "$PWD/auth_codes" "$HOME"/auth_codes
ln -sf "$PWD/alacritty" "$HOME"/alacritty
ln -sf "$PWD/vim" "$HOME"/.config/vim
ln -sf "$PWD/nvim" "$HOME"/.config/nvim

cd "$HOME"
rm .bash_history
rm .bash_logout
rm .bashrc

# dependencies
sudo apt-add-repository ppa:ansible/ansible

sudo apt-get install \
	make \
	git \
	wget \
	curl \
	gnupg \
	zip \
	unzip \
	build-essential \
	fzf \
	bat \
	tmux \
	ripgrep \
	gh \
	ansible

# nvim
export VIMINIT="source ~/.config/vim/.vimrc"
sudo snap install nvim --classic

# java dev
sudo apt-get install \
	openjdk-11-jdk \
	openjdk-17-jdk \
	maven \
	gradle

export JAVA_HOME_11=/usr/lib/jvm/java-11-openjdk-amd64
export JAVA_HOME_17=/usr/lib/jvm/java-17-openjdk-amd64
export JAVA_HOME=$JAVA_HOME_11
export MAVEN_HOME=/usr/share/maven
export GRADLE_HOME=/usr/share/gradle
export PATH=$JAVA_HOME/bin:$JAVA_HOME_11/bin:$JAVA_HOME_17/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH

# js dev
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts

npm install -g @angular/cli

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

export CHROME_BIN='/usr/bin/google-chrome'

# python dev
sudo apt istall python3

# go dev
wget https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin

# docker
curl -fsSL https://get.docker.com | sh

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# digital ocean
wget https://github.com/digitalocean/doctl/releases/download/v1.101.0/doctl-1.101.0-linux-amd64.tar.gz
tar xf ~/doctl-1.101.0-linux-amd64.tar.gz
sudo mv ~/doctl /usr/local/bin
doctl auth init

# sap sf
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update
sudo apt-get install cf8-cli
cf install-plugin multiapps
wget https://github.com/SAP/cloud-mta-build-tool/releases/download/v1.2.27/cloud-mta-build-tool_1.2.27_Linux_amd64.tar.gz
tar xvzf cloud-mta-build-tool_1.2.27_Linux_amd64.tar.gz
npm install -g mbt
