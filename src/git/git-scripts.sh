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

# Push branch
gpsh(){
    git push
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
gbr(){
    git branch
}

# List the current git branch
cbr(){
    git rev-parse --abbrev-ref HEAD
}

# Writes git changelog to file
gclog(){
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Not inside a Git repository. Exiting function."
        return
    fi

    # Clear or create the changelog file
    echo -n "" > changelog.md

    # Retrieve repository URL
    REPO_URL="https://github.com/$(git config --get remote.origin.url | sed 's/^git@github.com://' | sed 's/\.git$//' | tr -d '\n')"

    # Generate Markdown content for all commits
    git log --pretty=format:"**Commit:** [%h]($REPO_URL/commit/%H)  
    &emsp;&emsp;**Author:** %an <%ae>  
    &emsp;&emsp;**Committer:** %cn <%ae>  
    &emsp;&emsp;**When:** %ad  
    &emsp;&emsp;**Body:** %f   
    " --date=format-local:"<br>
    &emsp;&emsp;&emsp;&emsp;**Date**: %m/%d/%y<br>
    &emsp;&emsp;&emsp;&emsp;**Time**: %H:%M<br>
    &emsp;&emsp;&emsp;&emsp;**Timezone**: %z"  >> changelog.md
}

# Git blame
gbl(){
    filename=$1
    local start_line=${2:-1}  # Default start line is 1 if not provided
    local end_line=${3:-999999}
    # Check if a filename is provided
    if [ -z "$filename" ]; then
        echo "Usage: $0 <filename>"
        exit 1
    fi

    # Use git blame to get blame information for the entire file
    blame_output=$(git blame --line-porcelain "$filename" 2>/dev/null)

    # Initialize variables to store commit information
  
    line_num=1;
    line_count=0

    # Iterate over each line in the blame output
    for line in "${(@f)blame_output}"; do
        # if [[ "$line_num" -lt "$start_line "]]; then
        #     ((line_num++))
        # fi
        # Check if the line contains the commit hash and line number
        if [[ "$line" =~ ^([0-9a-f]{40})\ ([0-9]+)(\ [0-9]+)?\ ([0-9]+)$ ]]; then
            # Extract commit hash and line number
            commit_hash="${match[1]}"        
            short_commit_hash=$(git rev-parse --short "$commit_hash" 2>/dev/null)
            short_commit_hash=${short_commit_hash/0000000/New}
        fi
        # Check if the line contains the author information
        if [[ "$line" =~ ^author\ (.*)$ ]]; then
            # Extract author
            author=$(sed 's/Not Committed Yet//' <<< "${match[1]}")
            author=${author:0:20}
        fi
        # Check if the line contains the summary
        if [[ "$line" =~ ^summary\ (.*)$ ]]; then
            # Extract summary
            summary=$(sed '/Version of/ s/.*/ /' <<< "${match[1]}")
            summary=${summary:0:60}
        fi
        # Check if the line contains the line content
        if [[ "$content_line" == "1" ]]; then
            # Print the commit information for the line
            printf "Line %-5s%-9s%-22s%-60s%-20s\n" "$line_num" "$short_commit_hash" "$author" "$summary" "$line"
            line_count=0
            content_line="0"
            ((line_num++))
        fi
        if [[ "$line" =~ ^filename\ (.*)$ ]]; then
            content_line="1"
        fi
        ((line_count++))
    done
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

documentCommand "git" "commits" "gs" "Get status of modified and committed files"
documentCommand "git" "branches" "gp" "Pull branch from remote repository"
documentCommand "git" "branches" "gpsh" "Push branch to remote repository"
documentCommand "git" "branches" "gc" "Checkout an existing branch"
documentCommand "git" "commits" "report" "gl" "Print commit history with graphical branches"
documentCommand "git" "repos" "gcr" "Clone remote repository"
documentCommand "git" "branches" "gcd" "Checkout dev branch"
documentCommand "git" "branches" "gsw" "Switch to previous branch"
documentCommand "git" "branches" "gmd" "Merge dev into current branch"
documentCommand "git" "branches" "gcb" "Checkout new branch"
documentCommand "git" "branches" "gbd" "Delete local branch"
documentCommand "git" "branches" "gbr" "Print all branches"
documentCommand "git" "branches" "cbr" "Print current branch"
documentCommand "git" "commits" "report" "gclog" "Output git commit changelog to file"
documentCommand "git" "commits" "report" "gbl" "Outputs custom git blame for file"
documentCommand "git" "repos" "cloneRepos" "Clones list of repositories from a file"