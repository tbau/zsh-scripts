#!/bin/bash
# This script will auto activate and deactivate a nvm version
# on changing directory if it finds a .nvmrc file in a directory
load-nvm() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use --silent
  elif [[ $(nvm version) != $(nvm version default) ]]; then
    nvm use default --silent
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvm
load-nvm