[[ $TERM != "screen" ]] && exec tmux
test -f ~/.aliases && . ~/.aliases

export ConEmuDefaultCp=65001
export PYTHONIOENCODING=utf-8
export TERM=cygwin

function _update_ps1(){
	PS1="$(~/Projects/dotfiles/powerline-shell/powerline-shell.py $? 2> /dev/null)"
}

PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"