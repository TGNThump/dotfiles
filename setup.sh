#!/usr/bin/env bash

function checkDeps(){
	for dep in $*; do
		command -v $dep >/dev/null 2>&1 || { echo >&2 "I require $dep but it's not installed.  Aborting."; popd; exit 1; }
	done
}

pushd $(pwd)
cd "$(dirname "${BASH_SOURCE}")"

# Generate SSH and GPG Keys and Configure Git.
checkDeps keybase gpg git ssh-add ssh-agent tmux
source genkeys.sh

# Pull the latest version of this repo.
git pull origin master

for filename in .*; do
	if [[ $filename != "." && $filename != ".." && $filename != ".git" ]]; then
		echo $filename
		rm ~/$filename
		ln $filename ~/$filename
	fi
done

source ~/.bashrc
popd