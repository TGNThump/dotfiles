#!/usr/bin/env bash

# SSH KEY
if [[ ! -f ~/.ssh/id_rsa ]]; then
	echo "SSH Key Not Found. Generating..."
	mkdir -p ~/.ssh/
	ssh-keygen -t rsa -b 4096 -C "ben@pilgrim.me.uk $(hostname)" -f ~/.ssh/id_rsa
	clip < ~/.ssh/id_rsa.pub
	echo "Public Key Coppied to clipboard, opening GitHub."
	start "https://github.com/settings/ssh/new"
	read -p "Press enter to continue"
	if [[ -f /k/public/thump/.ssh/authorized_keys ]]; then
		echo "Adding key to KeyBase authorized_keys"
		(echo ""; cat ~/.ssh/id_rsa.pub) >> /k/public/thump/.ssh/authorized_keys
	fi
fi

echo "Found SSH key."

keys=$(ssh-add -l)
if [[ $keys =~ ^[[:alpha:][:space:].]*$ ]]; then
	eval $(ssh-agent -s) &> /dev/null
	ssh-add ~/.ssh/id_rsa
fi

# GPG KEY
keys=$(gpg --list-secret-keys --keyid-format LONG)

if [[ ! $keys =~ sec[[:space:]].*/([[:alnum:]]*)[[:blank:]] ]]; then
	echo "GPG Key Not Found. Importing...";
	keybase pgp export --secret | gpg --allow-secret-key-import --import
	keys=$(gpg --list-secret-keys --keyid-format LONG)
	if [[ ! $keys =~ sec[[:space:]].*/([[:alnum:]]*)[[:blank:]] ]]; then
		echo "Failed to import key."
		exit
	fi
fi

GPG_KEY_ID=${BASH_REMATCH[1]};
echo "Found GPG key: $GPG_KEY_ID."

# GIT CONFIG
echo "Set GIT configuration.";
git config --global user.email "ben@pilgrim.me.uk"
git config --global user.name "Ben Pilgrim"
git config --global user.signingkey $GPG_KEY_ID
git config --global commit.gpgsign true