#!/usr/bin/env bash

pushd $(pwd) > /dev/null
cd "$(dirname "${BASH_SOURCE}")"

rm ~/.bashrc

for f in $(find ./ -maxdepth 1 -type d | grep -Ev '.git$|bin|appdata' | cut -d '/' -f 2 )
do
    stow -R $f -t ~/
done

if [ -x "$(command -v cmd.exe)" ]; then
	cp -a ./appdata/local/* $(wslpath -u $(powershell.exe '$env:LocalAppData') | sed 's/\r$//')
	#cp -a ./appdata/roaming/* $(wslpath -u $(powershell.exe '$env:AppData') | sed 's/\r$//')
fi

popd > /dev/null