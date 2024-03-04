#!/bin/zsh
# Aliases uses for git commands

if [[ -z "$git_scripts_file_sourced" ]]; then
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

    # Git add interactive
    gai(){
        git add -i
    }

    # Add files to staged files and stash them
    gstsh(){
        git add .
        git stash
    }

    # Get files from stash and add them to branch
    gstshp(){
        git stash pop
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

    # List all branches
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

    # Displays remote directory or file of a repo
    grf() {
        # Check if help option is provided
        if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
            echo "Get contents of a file or directory from a GitHub repository."
            echo "Usage: grf <owner> <repo> <branch> <file_path>"
            echo "       grf -h | --help"
            echo
            echo "Options:"
            echo "  <owner>      Repository owner or organization."
            echo "  <repo>       Repository name."
            echo "  <branch>     Branch name."
            echo "  <file_path>  Path to the file or directory."
            echo "               If <file_path> ends with '/', it is treated as a directory."
            echo "  -h, --help   Display this help message."
            return 0
        fi

        # Check if correct number of arguments is provided
        if [ "$#" -ne 4 ]; then
            echo "Usage: gsf <owner> <repo> <branch> <file_path>"
            return 1
        fi

        local owner="$1"
        local repo="$2"
        local branch="$3"
        local file_path="${4%/}" 
        local headers="Accept: application/vnd.github.v3.raw"
        
        if [[ -n "$GITHUB_TOKEN" && "$USE_GITHUB_AUTHENTICATION" == true ]]; then
            headers="$headers; Authorization: Bearer $GITHUB_TOKEN"
        fi

        # Fetch the contents of the directory from GitHub API
        local url="https://api.github.com/repos/$owner/$repo/contents/$file_path?ref=$branch"
        local response=$(curl -s -H "Accept: application/vnd.github.v3.raw"  "$url")
        
        # Check if curl command was successful
        if [ $? -ne 0 ]; then
            echo "Failed to fetch directory contents from GitHub."
            return 1
        fi

        local entries=$(echo "$response" | jq -r '.[] | "\(.type) \(.name)"' 2>/dev/null)

        if [ -z "$entries" ]; then
            echo "$response"
        else     
            # Display the file and directory names
            echo "Contents of directory '$file_path':"
            while IFS= read -r entry; do
                type=$(echo "$entry" | awk '{print $1}')
                name=$(echo "$entry" | awk '{$1=""; print $0}')
                if [ "$type" = "file" ]; then
                    echo "File: $name"
                elif [ "$type" = "dir" ]; then
                    echo "Directory: $name"
                else
                    echo "Unknown type: $type"
                fi
            done <<< "$entries"
        fi
    }

    # Function to set USE_GITHUB_AUTHENTICATION
    suga() {
        if [[ "$1" == "-h" || "$1" == "--help" ]]; then
            echo "Usage: suga: Set the USE_GITHUB_AUTHENTICATION variable to true, enabling GitHub authentication."
            echo "      Note: If GITHUB_TOKEN is not set, GitHub authentication will not be used."
            return 0
        fi

        if [[ -z "$GITHUB_TOKEN" ]]; then
            echo "Warning: GITHUB_TOKEN variable is not set. GitHub authentication will not be used."
        fi

        export USE_GITHUB_AUTHENTICATION=true
        echo "USE_GITHUB_AUTHENTICATION set to true."
        save_vars
    }

    # Function to unset USE_GITHUB_AUTHENTICATION
    usuga() {
        if [[ "$1" == "-h" || "$1" == "--help" ]]; then
            echo "Usage: usuga: Set the USE_GITHUB_AUTHENTICATION variable to false, disabling GitHub authentication."
            return 0
        fi

        export USE_GITHUB_AUTHENTICATION=false
        echo "USE_GITHUB_AUTHENTICATION set to false."
        save_vars
    }

    # Outputs custom git blame for file
    gbl(){
        if [[ -z "$1" ]]; then
            echo "Usage: $(basename "$0") <filename>"
            echo
            return 1
        elif [[ "$1" = "-h" || "$1" = "--help" ]]; then
            echo "Usage: gbl <filename> [-n] [<start_line>] [<end_line>]"
            echo "       gbl -h | --help"
            echo
            echo "Options:"
            echo "  <filename>    Required. The name of the file to perform blame on."
            echo "  -n            Optional. Only show newly added lines."
            echo "  <start_line>  Optional. The starting line number for blame (default: 1)."
            echo "  <end_line>    Optional. The ending line number for blame."
            echo
            echo "If -n is provided, the <start_line> and <end_line> parameters are ignored."
            echo "If <start_line> and/or <end_line> are not provided, the entire file is considered."
            return 0
        elif [[ "$1" = "-n" ]]; then
            if [[ -z "$2" ]]; then
                echo "Usage: gbl -n <filename>"
                echo
                return 1
            elif [[ ! -e "$2" ]]; then
                echo "File '$2' not found"
                return 1
            fi
            filename=$2
            pattern="New      "
            start_line=${4:-1}
            end_line=${5:-999999}
        elif [[ "$2" = "-n" ]]; then
            if [[ ! -e "$1" ]]; then
                echo "File '$1' not found"
                return 1
            fi
            filename=$1
            pattern="New      "
            start_line=${3:-1}
            end_line=${4:-999999}
        else
            filename=$1
            pattern="Line"
            start_line=${2:-1}
            end_line=${3:-999999}
            if [[ ! -e "$filename" ]]; then
                echo "File '$filename' not found"
                return 1
            fi
        fi

        if [[ "$start_line" != "1" || "$end_line" != "999999" ]]; then
            # Use git blame to get blame information for the entire file
            blame_output=$(git blame -L $start_line,$end_line --line-porcelain "$filename" 2>/dev/null)
        else
            blame_output=$(git blame --line-porcelain "$filename" 2>/dev/null)
        fi
        # Initialize variables to store commit information
    
        line_num=$start_line;
        
        # Iterate over each line in the blame output
        for line in "${(@f)blame_output}"; do
            # Check if the line contains the commit hash and line number
            if [[ "$line" =~ ^([0-9a-f]{40})\ ([0-9]+)(\ [0-9]+)?\ ([0-9]+)$ ]]; then
                skip_line="0"
                # Extract commit hash and line number
                commit_hash="${match[1]}"        
                short_commit_hash=$(git rev-parse --short "$commit_hash" 2>/dev/null)
                short_commit_hash=${short_commit_hash/0000000/New}

                if [[ "$pattern" = "New      " && "$short_commit_hash" != "New" ]]; then
                    skip_line="1"
                    ((line_num++))
                fi
            fi

            if [[ "$skip_line" -eq "1" ]]; then
                continue 
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
            if [[ "$content_line" = "1" ]]; then
                # Print the commit information for the line
                printf "Line %-5s%-9s%-22s%-60s%-20s\n" "$line_num" "$short_commit_hash" "$author" "$summary" "$line" | grep "$pattern"
                content_line="0"            
                ((line_num++))
            fi
            if [[ "$line" =~ ^filename\ (.*)$ ]]; then
                content_line="1"
            fi
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

    export USE_GITHUB_AUTHENTICATION=false
    source "$(dirname "${zsh_scripts_directories["git_scripts_dir"]}")/shared/shared-scripts.sh"
    add_var "USE_GITHUB_AUTHENTICATION"
    load_vars

    documentCommand "git" "commits" "gs" "Get status of modified and committed files"
    documentCommand "git" "branches" "gp" "Pull branch from remote repository"
    documentCommand "git" "branches" "gpsh" "Push branch to remote repository"
    documentCommand "git" "commits" "file" "gai" "Add files to commit interactively"
    documentCommand "git" "commits" "file" "stash" "gstsh" "Add files to staged files and stash them"
    documentCommand "git" "commits" "file" "stash" "pop" "gstshp" "Get files from stash and add them to branch"
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
    documentCommand "git" "repos" "commits" "report" "file" "directory" "grf" "Displays remote directory or file of a repo"
    documentCommand "git" "repos" "commits" "authentication" "grf" "report" "suga" "Set USE_GITHUB_AUTHENTICATION to true"
    documentCommand "git" "repos" "commits" "authentication" "grf" "report" "usuga" "Set USE_GITHUB_AUTHENTICATION to false"
    documentCommand "git" "repos" "cloneRepos" "Clones list of repositories from a file"
fi

git_scripts_file_sourced=true