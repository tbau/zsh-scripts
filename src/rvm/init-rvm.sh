#!/bin/zsh
# This script initializes the rvm ruby version manager

if [[ -z "$init_rvm_file_sourced" ]]; then
  source ~/.rvm/scripts/rvm
fi

init_rvm_file_sourced=true