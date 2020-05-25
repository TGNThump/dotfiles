#!/usr/bin/env bash

pushd $(pwd) > /dev/null
cd "$(dirname "${BASH_SOURCE}")"

echo 'Updating apt repositories.'
sudo apt-get update -y > /dev/null

echo 'Upgrading system.'
sudo apt-get dist-upgrade -y > /dev/null

echo 'Installing curl.'
sudo apt-get install curl -y > /dev/null

echo 'Installing wget.'
sudo apt-get install wget -y > /dev/null

echo 'Installing nano.'
sudo apt-get install nano -y > /dev/null

echo 'Installing git.'
sudo apt-get install git -y > /dev/null

echo 'Installing gpg.'
sudo apt-get install gpg -y > /dev/null

echo 'Installing tmux.'
sudo apt-get install tmux -y > /dev/null

echo 'Installing golang.'
sudo apt-get install golang -y > /dev/null

echo 'Installing stow.'
sudo apt-get install stow -y > /dev/null

echo 'Installing locale.'
sudo locale-gen en_GB.UTF-8 > /dev/null

echo 'Installing keybase.'
sudo curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb -s
sudo sudo apt-get install ./keybase_amd64.deb -y > /dev/null
sudo rm ./keybase_amd64.deb
run_keybase -g > /dev/null

echo 'Installing powerline-go.'
export GOPATH=~/.go
go get -u github.com/justjanne/powerline-go

popd > /dev/null