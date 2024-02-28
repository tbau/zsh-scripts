#!/bin/zsh
# Aliases uses for git commands

# Git status
gs(){
    git status
}

# Pull branch
gp(){
    git pull
}

# Git checkout
gc(){
    git checkout $1
}

# Git log with graphs
gl(){
    git log --oneline --graph --decorate
}

# Git clone repo
gcr() {
    if [ -z "$1" ]; then
        echo "Usage: gcr <repository-url>"
        return 1
    fi

    repo_url=$1

    # Check if the repository exists
    if git ls-remote --exit-code "$repo_url" &> /dev/null; then
        # Repository is safe, proceed with cloning
        git clone "$repo_url"
    else
        echo "Repository does not exist or is not accessible."
        return 1
    fi
}

# Checkout dev branch
gcd(){
    git checkout dev
}

#Switch to previous branch
gsw(){
    git switch -
}

# Merge dev
gmd(){
    git merge dev
}

# Git checkout branch
gcb(){
    git checkout -b $1
}

# Git branch delete
gbd(){           
    local branch_name="$1"
    # Check if the branch exists
    if git show-ref --quiet --verify "refs/heads/$branch_name"; then
        print -n "Are you sure you want to delete the branch '$branch_name'? [y/N]: "
        read response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            git branch -D "$branch_name"
        else
            echo "Branch deletion canceled."
        fi
    else
        echo "Error: Branch '$branch_name' does not exist."
    fi
}

# List the all branches
gb(){
    git branch
}

# List the current git branch
cb(){
    git rev-parse --abbrev-ref HEAD
}

# Writes git changelog to file
gclog(){
    git log --pretty=format:"%h - %an, %ar : %s" > changelog.txt
}

# Downloads list of repositories from a file
cloneRepos(){
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

source "$(dirname "${zsh_scripts_directories["git_scripts_dir"]}")/shared/shared-scripts.sh"

documentCommand "git" "gs" "Get status of modified and committed files"
documentCommand "git" "gp" "Pull branch from remote repository"
documentCommand "git" "gc" "Checkout an existing branch"
documentCommand "git" "gl" "Print commit history with graphical branches"
documentCommand "git" "gcr" "Clone remote repository"
documentCommand "git" "gcd" "Checkout dev branch"
documentCommand "git" "gsw" "Switch to previous branch"
documentCommand "git" "gmd" "Merge dev into current branch"
documentCommand "git" "gcb" "Checkout new branch"
documentCommand "git" "gbd" "Delete local branch"
documentCommand "git" "gb" "Print all branches"
documentCommand "git" "cb" "Print current branch"
documentCommand "git" "gclog" "Output git commit changelog to file"
documentCommand "git" "repos" "cloneRepos" "Clones list of repositories from a file"