function path(){
	echo $PATH | tr : '\n'
}

function up() { cd $(eval printf '../'%.0s {1..$1}) && pwd; }

function weather() { curl -s http://wttr.in/$2; }

alias sublime='"/mnt/c/Program Files/Sublime Text 3/subl.exe"'

alias explorer=explorer.exe

alias cls=clear
