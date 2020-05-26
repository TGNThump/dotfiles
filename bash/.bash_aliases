function path(){
	echo $PATH | tr : '\n'
}

function git(){
	local root=`command git rev-parse --show-toplevel`

	if [[ -d "$root/.git/svn" ]]; then
			case "$1" in
					push)
							command git svn dcommit --rmdir
							return
							;;
					pull)
							command git svn rebase
							return
							;;
			esac
	fi

	command git "$@"
}

function up() { cd $(eval printf '../'%.0s {1..$1}) && pwd; }

function weather() { curl -s http://wttr.in/$2; }

alias sublime='"/mnt/c/Program Files/Sublime Text 3/subl.exe"'

alias explorer=explorer.exe

alias cls=clear
