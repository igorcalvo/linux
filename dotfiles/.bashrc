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

. "$HOME/.cargo/env"

SXHKD_SHELL="/bin/sh"
export SXHKD_SHELL="/bin/sh"

SUDO_EDITOR=/usr/bin/nvim
export SUDO_EDITOR

LANG=en_US.UTF-8
export LANG=en_US.UTF-8

LC_CTYPE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

LC_ALL=en_US.UTF-8
export LC_ALL=en_US.UTF-8

