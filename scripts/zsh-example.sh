#!/bin/sh

# Install ZSH
sudo apt-get install zsh -y

sudo chsh -s $(which zsh) $USER

# Install Antigen
rm -rf ~/antigen
git clone https://github.com/zsh-users/antigen.git ~/antigen

# Configure Antigen
cat <<-EOF > ~/.zshrc
	# Antigen
	source ~/antigen/antigen.zsh

	antigen use oh-my-zsh

	antigen bundle git
	antigen bundle zsh-users/zsh-syntax-highlighting
	antigen bundle command-not-found
	antigen bundle lukechilds/zsh-nvm
	antigen bundle npm
	antigen bundle yarn
	antigen bundle docker
	antigen bundle docker-compose

	antigen theme robbyrussell

	antigen apply

	# Environments
	export PATH="/vagrant/scripts:\$PATH"
	export RSYNCED="$1"
EOF
