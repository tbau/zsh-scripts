#!/bin/zsh
# This script will auto activate and deactivate a pyenv virtual environment
# on changing directory if it finds a .python-version file in a directory
# If pyenv is manually activated, will not deactivate on leaving directory

export PYENV_MANUAL_ACTIVATED="0"

load-pyenv() {
  if [ -z $VIRTUAL_ENV ]; then
    if [ -f .python-virtualenv ]; then
      pyenv activate $(cat .python-virtualenv)
      export PYENV_MANUAL_ACTIVATED="0"
    fi
  else
    if [[ ! -f .python-virtualenv && "$PYENV_MANUAL_ACTIVATED" = "0" ]]; then
      pyenv deactivate
      export PYENV_MANUAL_ACTIVATED="1"
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load-pyenv
load-pyenv