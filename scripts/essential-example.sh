#!/bin/sh

# Update APT repositories
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update
sudo apt-get dist-upgrade -y

# Install essential packages
sudo apt-get install build-essential htop -y

# Install and configure Git
sudo apt-get install git -y

rm -f ~/.gitconfig

git config --global diff.compactionHeuristic true

sudo chmod +x "$1"
git config --global pager.log "$1 | less"
git config --global pager.show "$1 | less"
git config --global pager.diff "$1 | less"
git config --global interactive.diffFilter "$1"
