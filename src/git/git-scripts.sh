#!/bin/zsh
# Aliases uses for git commands

# Checkout dev branch
gcd(){
    git checkout dev
}

#Switch to previous branch
gsw(){
    git switch -
}

# List the current git branch
branch(){
    git rev-parse --abbrev-ref HEAD
}

# Writes git changelog to file
git-changelog(){
    git log --pretty=format:"%h - %an, %ar : %s" > changelog.txt
}

# Downloads list of repositories from a file
repoClone(){
    while IFS= read -r repo; do
        repo_name=${repo##*/}  # Get the last component of the URL (basename)
        repo_name=${repo_name%.git}  # Remove the .git extension
        echo $repo_name
        if [ ! -d "$repo_name" ]; then
            git clone "$repo"
        else
            echo "Repository $repo_name already exists, skipping..."
        fi
    done < "$1"
}

# Used to setup pathing
# Do not remove or script will not know how to find other scripts
declare -A zsh_scripts_directories
if [ -n "$ZSH_VERSION" ]; then
    zsh_scripts_directories["git_scripts_dir"]=$(dirname "${(%):-%x}")
elif [ -n "$BASH_VERSION" ]; then
    zsh_scripts_directories["git_scripts_dir"]=$(dirname "${BASH_SOURCE[0]}")
fi