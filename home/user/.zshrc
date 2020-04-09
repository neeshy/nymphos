#!/bin/zsh

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

autoload -U compinit
compinit

#setopt correctall

autoload -U promptinit
promptinit
prompt gentoo
