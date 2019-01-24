#!/usr/bin/env bash

function checkDeps(){
	for dep in $*; do
		command -v $dep >/dev/null 2>&1 || { echo >&2 "I require $dep but it's not installed.  Aborting."; popd; exit 1; }
	done
}

function link(){
	echo ${2:-~}/$1;
	mkdir -p $(dirname ${2:-~}/$1)
	if [[ -f ${2:-~}/$1 ]]; then
		rm ${2:-~}/$1
	fi
	ln $1 ${2:-~}/$1
}

pushd $(pwd)
cd "$(dirname "${BASH_SOURCE}")"

# Generate SSH and GPG Keys and Configure Git.
checkDeps keybase gpg git ssh-add ssh-agent tmux python
source genkeys.sh

# Pull the latest version of this repo.
git pull origin master



for filename in .*; do
	if [[ $filename != "." && $filename != ".." && $filename != ".git" ]]; then
		link $filename
	fi
done

if [[ $TERM == "cygwin" ]]; then
	checkDeps gcc winpty
	link src/cygwin_ls_readdir.c /usr/local
	link bin/cygwin-ls.py /usr/local
fi

source ~/.bashrc
popd