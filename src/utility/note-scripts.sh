# Create a note management system that lets me edit create and delete notes and tag as well

 if [[ -z "$note_scripts_file_sourced" ]]; then
    # Create a note
    ncreate() {
        local note_file="$HOME/.notes/$(date +%Y-%m-%d_%H-%M-%S).md"
        touch "$note_file"
        vim "$note_file"
    }

    # List all notes
    nlist() {
        find "$HOME/.notes" -type f -name "*.md" -printf "%T@ %p\n" | cut -f2- -d' '
    }

    # Edit a note
    nedit() {
        local note_file="$(fzf --query="$1" --select-1 --exit-0 --tac < <(nlist))"
        if [ -n "$note_file" ]; then
            vim "$note_file"
        fi
    }

    # Delete a note
    ndelete() {
        local note_file="$(fzf --query="$1" --select-1 --exit-0 --tac < <(nlist))"
        if [ -n "$note_file" ]; then
            rm "$note_file"
        fi
    }
    # Add a tag to a note
    ntag() {
        local note_file="$(fzf --query="$2" --select-1 --exit-0 --tac < <(nlist))"
        if [ -n "$note_file" ]; then
            local tag=$(echo "$1" | tr '[:upper:]' '[:lower:]')
            local tag_file="$HOME/.notes/tags/$tag"

            # Ensure the tags directory exists
            mkdir -p "$HOME/.notes/tags"

            # Create the tag file if it doesn't exist
            touch "$tag_file"

            # Escape special characters in the note file path for sed
            local escaped_note_file=$(echo "$note_file" | sed 's/[\/&]/\\&/g')

            if ! grep -q "^$escaped_note_file$" "$tag_file"; then
                echo "$note_file" >> "$tag_file"
            fi
        fi
    }

    # Remove a tag from a note
    ntagr() {
        local note_file="$(fzf --query="$2" --select-1 --exit-0 --tac < <(nlist))"
        if [ -n "$note_file" ]; then
            local tag=$(echo "$1" | tr '[:upper:]' '[:lower:]')
            local tag_file="$HOME/.notes/tags/$tag"

            # Escape special characters in the note file path for sed
            local escaped_note_file=$(echo "$note_file" | sed 's/[\/&]/\\&/g')

            if [ -f "$tag_file" ]; then
                sed -i "/^$escaped_note_file$/d" "$tag_file"
            fi

             # Delete the tag file if it's empty
            if [ ! -s "$tag_file" ]; then
                rm "$tag_file"
            fi
        fi
    }

    # List all tags
    ntags() {
        find "$HOME/.notes/tags" -type f -printf "%f\n" | sort -u
    }

    # List all notes with a specific tag
    ntagged() {
        local tag=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        local tag_file="$HOME/.notes/tags/$tag"

        if [ -f "$tag_file" ]; then
            cat "$tag_file"
        fi
    }

    # Rename a note
    nrename() {
        local note_file="$(fzf --query="$2" --select-1 --exit-0 --tac < <(nlist))"
        if [ -n "$note_file" ]; then
            local new_name=$(echo "$1" | tr '[:upper:]' '[:lower:]')
            mv "$note_file" "$(dirname "$note_file")/${new_name}.md"
        fi
    }

    # List all tags for a specific note
    ntagsd() {
        local note_file="$(fzf --query="$1" --select-1 --exit-0 --tac < <(nlist))"
        if [ -n "$note_file" ]; then
            find "$note_file" -type f -name "*.md" -exec grep -ohE '^# [a-zA-Z0-9_\-]+' {} \; | sort -u
        fi
    }

    # List all tags for each note
    nltags() {
    # Iterate through all note files
        for note_file in $(nlist); do
            echo "Note: $note_file"
            echo "Tags:"
            
            # Find all tags associated with this note file
            for tag_file in "$HOME/.notes/tags"/*; do
                if grep -q "^$note_file$" "$tag_file"; then
                    echo "  - $(basename "$tag_file")"
                fi
            done
            echo
        done
    }


    # Used to setup pathing
    # Do not remove or script will not know how to find other scripts
    declare -A zsh_scripts_directories
    if [ -n "$ZSH_VERSION" ]; then
        zsh_scripts_directories["note_scripts_dir"]=$(dirname "${(%):-%x}")
    elif [ -n "$BASH_VERSION" ]; then
        zsh_scripts_directories["note_scripts_dir"]=$(dirname "${BASH_SOURCE[0]}")
    fi

    documentCommand "notes" "add" "tag" "ntag" "Add a tag to a note"
    documentCommand "notes" "remove" "tag" "ntagr" "Remove a tag from a note"
    documentCommand "notes" "list" "tags" "ntags" "List all tags"
    documentCommand "notes" "list" "notes" "tagged" "ntagged" "List all notes with a specific tag"
    documentCommand "notes" "rename" "file" "nrename" "Rename a note"
    documentCommand "notes" "list" "tags" "ntagsd" "List all tags for a specific note"
    documentCommand "notes" "list" "tags" "nltags" "List all tags for each note"
 fi

note_scripts_file_sourced=true