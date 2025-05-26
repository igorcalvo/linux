#
# ~/.bashrc
#

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# export SXHKD_SHELL="/bin/sh"
PATH=$PATH:/home/calvo/.local/bin
. "$HOME/.cargo/env"

export LANG=en_US.UTF-8
# export LC_CTYPE=en_US.UTF-8
# export LC_ALL=en_US.UTF-8

export EDITOR=/usr/bin/nvim
export SUDO_EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

export XDG_DOWNLOAD_DIR=$HOME/downloads
export XDG_CONFIG_HOME=$HOME/.config

# if uwsm check may-start && uwsm select; then
# 	exec uwsm start default
# fi
