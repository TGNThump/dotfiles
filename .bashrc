[[ $TERM != "screen" ]] && exec tmux
test -f ~/.aliases && . ~/.aliases

export ConEmuDefaultCp=65001
export PYTHONIOENCODING=utf-8
export TERM=cygwin