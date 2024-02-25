#!/bin/zsh
# This script will setup the path for pyenv and initialize both
# pyenv and pyenv virualenv

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv every time you start a new shell
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

eval "$(pyenv virtualenv-init -)"