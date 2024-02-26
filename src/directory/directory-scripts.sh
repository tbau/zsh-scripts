#!/bin/zsh

# Find unique lines and count of each line for every file in a directory
# Arguments:
#   Directory: directory to scan
unique() {
    data_dir="$1"
    cat "$data_dir"/* | sort | uniq -c
}

# Format Json File
# Arguments:
#   File Name: file to output the json of
fjs() {
    cat "$1" | jq .
}

# Find Files by Name
# Arguments:
#   File Name: file to find
#   Accepts partial matching
ff() {
    find -L "." -type f -name "*$1*"
}

# Count Files in Directory
# Arguments:
#   Directory: directory to find file count of
#   Defaults to current directory if no argument is passed
cf() {
    if [[ -n "$1" ]]; then
        find -L "$1" -type f | wc -l
    else
        find -L "." -type f | wc -l
    fi
}

# Check if the tree function already exists to not conflict with existing tree command
if ! type tree >/dev/null 2>&1; then
    # Recursively lists files and directories in a directory tree.
    # Arguments:
    #   show_hidden (optional, default: false): If set to true, includes hidden files and directories in the output
    #   directory (optional, default: current directory): The directory to list
    #   indent (optional, default: empty string): The indentation string for visual tree representation
    tree() {
        local show_hidden="${1:-false}"
        local directory="${2:-.}"
        local indent="${3:-}"
        local file
        
        # Get the number of items in the directory
        local num_items
        if [ "$show_hidden" = true ]; then
            num_items=$(ls -A "$directory" | wc -l)
        else
            num_items=$(ls "$directory" | wc -l)
        fi
        local count=0
        
        # Loop through all files and directories in the current directory
        local files
        if [ "$show_hidden" = true ]; then
            if [ -n "$ZSH_VERSION" ]; then
                files=("$directory"/*(DN))
            else
                files=("$directory"/* "$directory"/.[!.]*)
            fi
        else
            files=("$directory"/*)
        fi
            
        for file in "${files[@]}"; do
            # Extract the base name of the file or directory
            local name=$(basename "$file")
            
            # Increment the count
            ((count++))

            # Determine the prefix to print based on the count
            local branch="${indent}├── "
            if [ "$count" -eq "$num_items" ]; then
                branch="${indent}└── "
            fi

            # Print the current file or directory with appropriate formatting
            echo -n "$branch"
            echo "$name"

            # If the current item is a directory, recursively list its contents
            if [ -d "$file" ]; then
                tree "$show_hidden" "$file" "${indent}│   "
            fi
        done
    }
fi

# Used to setup pathing
# Do not remove or script will not know how to find other scripts
declare -A zsh_scripts_directories
if [ -n "$ZSH_VERSION" ]; then
    zsh_scripts_directories["directory_scripts_dir"]=$(dirname "${(%):-%x}")
elif [ -n "$BASH_VERSION" ]; then
    zsh_scripts_directories["directory_scripts_dir"]=$(dirname "${BASH_SOURCE[0]}")
fi

# DO NOT UNCOMMENT AND USE IN THIS FILE
#
# To use this code, copy it to a script
# It must be placed in the script you want the path to
# You cannot make a function for it and call it from a seperate script
# You can declare a function in the same file to do it though
# This allows you to declare an array that will hold the absolute path of whatever
# file it is put in.
# The path can them be accessed from any other script that needs it
#
# declare -A file_path_directories
# if [ -n "$ZSH_VERSION" ]; then
#     file_path_directories["file_name"]=$(dirname "${(%):-%x}")
# elif [ -n "$BASH_VERSION" ]; then
#     file_path_directories["file_name"]=$(dirname "${BASH_SOURCE[0]}")
# fi
#
# To output the file path afterwards
#
# echo $file_path_directories["file_name"]