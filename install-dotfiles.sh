#!/usr/bin/env bash

pushd $(pwd) > /dev/null
cd "$(dirname "${BASH_SOURCE}")"

rm ~/.bashrc

git config --global core.excludesfile ~/.gitignore

for f in $(find ./ -maxdepth 1 -type d | grep -Ev '\.git$|bin|appdata|\.idea' | rev | cut -d '/' -f 1 | rev )
do
    stow -R $f -t ~/
done

if [ -x "$(command -v cmd.exe)" ]; then
	cp -a ./appdata/local/* $(wslpath -u $(powershell.exe '$env:LocalAppData') | sed 's/\r$//')
	#cp -a ./appdata/roaming/* $(wslpath -u $(powershell.exe '$env:AppData') | sed 's/\r$//')
fi

popd > /dev/null