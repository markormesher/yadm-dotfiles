#! /usr/bin/env bash
#set -euo pipefail

SYSTEM_NAME=$(uname -s)

# Interactive shells only
[[ $- == *i* ]] || return

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Reasonable history size
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Better tab completion
if command -v brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  source "$(brew --prefix)/etc/bash_completion"
fi

#################
# Custom prompt #
#################

TXT_BOLD="$(tput bold)"
TXT_BLACK="$(tput setaf 0)"
TXT_RED="$(tput setaf 1)"
TXT_GREEN="$(tput setaf 2)"
TXT_YELLOW="$(tput setaf 3)"
TXT_MAGENTA="$(tput setaf 5)"
TXT_CYAN="$(tput setaf 6)"
TXT_RESET="$(tput sgr0)"

function git_info_for_prompt() {
  if git rev-parse 2> /dev/null; then
    branch_colour=$(git config user.email | grep markormesher > /dev/null 2>&1  && echo -n "$TXT_YELLOW" || echo -n "$TXT_RED")
    echo -ne "[ ${branch_colour}⌥ $(git rev-parse --abbrev-ref HEAD 2> /dev/null)${TXT_RESET} ]"
  else
    echo -ne ""
  fi
}

function shortened_dir() {
  dirs +0 | awk -F '/' '{ for(i=1;i<NF;i++) { printf(substr($i, 1, 1)); printf "/" }; printf $NF }'
}

function custom_prompt() {
  if [ "$USER" = "root" ]; then
    local user_and_host="[ ${TXT_RED}${TXT_BOLD}\u${TXT_RESET}${TXT_GREEN}${TXT_BOLD}@\h${TXT_RESET} ]"
  else
    local user_and_host="[ ${TXT_GREEN}${TXT_BOLD}\u@\h${TXT_RESET} ]"
  fi

  local cwd="[ ${TXT_CYAN}\$(shortened_dir)${TXT_RESET} ]"

  local prompt="$ "
  export PS1="\n┌─${user_and_host}${cwd}\$(git_info_for_prompt)\n└───$prompt"
}

custom_prompt

####################
# $PATH management #
####################

# core

PATH="/bin"
PATH="${PATH}:/sbin"
PATH="${PATH}:/usr/bin"
PATH="${PATH}:/usr/sbin"
PATH="${PATH}:/usr/local/bin"
PATH="${PATH}:/usr/local/sbin"

# user-owner binaries

PATH="${PATH}:${HOME}/bin"

# ubuntu snap

[ -d "/snap/bin" ] && PATH="${PATH}:/snap/bin"

# node

PATH="${PATH}:${HOME}/.npm-packages/bin"
[ -d "/usr/local/opt/node@16/bin" ] && PATH="${PATH}:/usr/local/opt/node@16/bin"

# sdk manager

[ -d "${HOME}/.sdkman/candidates/java/current/bin" ] && PATH="${PATH}:${HOME}/.sdkman/candidates/java/current/bin"
[ -d "${HOME}/.sdkman/candidates/kotlin/current/bin" ] && PATH="${PATH}:${HOME}/.sdkman/candidates/kotlin/current/bin"
[ -d "${HOME}/.sdkman/candidates/gradle/current/bin" ] && PATH="${PATH}:${HOME}/.sdkman/candidates/gradle/current/bin"

export PATH

###################################
# Per-service exports and aliases #
###################################

# bash

alias ..='cd ..'
alias cp='rsync -avz --progress'
alias sum="paste -sd+ - | bc"

if [[ "${SYSTEM_NAME}" == "Darwin" ]]; then
  alias awk='gawk'
  alias date='gdate'
  alias df='gdf'
  alias du='gdu'
  alias find='gfind'
  alias head='ghead'
  alias readlink='greadlink'
  alias sed='gsed'
  alias shuf='gshuf'
  alias split='gsplit'
  alias stat='gstat'
  alias tail='gtail'
  alias tar='gtar'
  alias xargs='gxargs'

  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

if command -v apt &> /dev/null; then
  alias apt='sudo apt'
fi

if [[ "${SYSTEM_NAME}" == "Darwin" ]]; then
  alias l='gls --color=auto -h --group-directories-first'
  alias ls='gls --color=auto -h --group-directories-first'
  alias ll='gls -la --color=auto -h --group-directories-first'
else
  alias l='ls --color=auto -h --group-directories-first'
  alias ls='ls --color=auto -h --group-directories-first'
  alias ll='ls -la --color=auto -h --group-directories-first'
fi

if [[ "${SYSTEM_NAME}" == "Darwin" ]]; then
  alias grep='ggrep --color=auto'
  alias egrep='gegrep --color=auto'
  command -v colordiff &>/dev/null && alias diff='colordiff -W$(( $(tput cols) - 2 ))'
else
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias diff='diff --color -W $(( $(tput cols) - 2 ))'
fi

# docker

alias dk='docker'
alias dkps="docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"

if command -v docker-compose &> /dev/null; then
  alias dc='docker-compose'
else
  echo "docker-compose is not on the path yet"
fi

# git

alias add='git add'
alias commit='git commit'
alias pull='git pull'
alias push='git push'

# gpg

GPG_TTY=$(tty)
export GPG_TTY

# java

alias java='${HOME}/.sdkman/candidates/java/current/bin/java'
alias javac='${HOME}/.sdkman/candidates/java/current/bin/javac'
JAVA_HOME=$( java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | cut -d '=' -f 2 | tr -d '[:space:]' )
export JAVA_HOME

function gw {
  if [ -f ./gradlew ]; then
    ./gradlew "$@"
  else
    echo "No ./gradlew here"
  fi
}

# TODO: gradle opts

# node

NPM_PACKAGES="${HOME}/.npm-packages"
if [ ! -d "${NPM_PACKAGES}" ]; then
  mkdir -p "${NPM_PACKAGES}"
fi

if which npm > /dev/null && ! which npm | grep "${NPM_PACKAGES}"; then
  ORIGINAL_NPM=$(which npm)
  $ORIGINAL_NPM config set prefix "${NPM_PACKAGES}"
fi

alias npm='${NPM_PACKAGES}/bin/npm'
alias npx='${NPM_PACKAGES}/bin/npx'
alias yarn='${NPM_PACKAGES}/bin/yarn'
alias yarnpkg='${NPM_PACKAGES}/bin/yarnpkg'

# SDK manager

export SDKMAN_DIR="${HOME}/.sdkman"
if [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]; then
  source "${SDKMAN_DIR}/bin/sdkman-init.sh"
fi

# tmux

alias tm="tmux attach || tmux new -s main"

# vim

export EDITOR='nvim'
alias v='nvim'
alias vim='nvim'

function vw {
  old_path="$(pwd)"
  cd ~/vimwiki
  nvim +:VimwikiIndex
  cd "$old_path"
}

function vd {
  old_path="$(pwd)"
  cd ~/vimwiki
  nvim +:VimwikiMakeDiaryNote
  cd "$old_path"
}
