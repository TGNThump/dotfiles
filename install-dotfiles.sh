#!/usr/bin/env bash

pushd $(pwd) > /dev/null
cd "$(dirname "${BASH_SOURCE}")"

rm ~/.bashrc

for f in $(find ./ -maxdepth 1 -type d | grep -Ev '.git$|bin' | cut -d '/' -f 2 )
do
    stow -R $f -t ~/
done

popd > /dev/null