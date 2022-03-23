# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

[[ $TERM != "screen" ]] && [ -z "$TMUX" ] && exec tmux

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

if [ -f ~/.bash_aliases ]; then
    test ~/.bash_aliases && . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export TERM=xterm-256color
export GOPATH=~/.go
export LANG=en_GB.UTF-8
export LANGUAGE=en_GB:en
export LC_ALL=en_GB.UTF-8
export GPG_TTY=$(tty)

if [ -x "$(command -v cmd.exe)" ]; then
    export DOCKER_HOST=tcp://localhost:2375
fi

function _update_ps1() {
    PS1="$($GOPATH/bin/powerline-go -modules venv,host,ssh,cwd,perms,git,svn,hg,jobs,exit,root -theme ${HOME}/.powerlinetheme.json -error $?)"
}

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi