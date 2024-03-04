#/bin/bash
if [[ -z "$shared_scripts_file_sourced" ]]; then
    declare -A commandAccArr
    declare -a commandIndArr
    declare -A commandTagArr

    documentCommand(){ 
        key=${@:(-2):1}  
        while [ $# -gt 2 ]; do
            commandTagArr[$key]="$commandTagArr[$key] $1"
            shift
        done
        commandTagArr[$key]="$commandTagArr[$key] $key "
        commandAccArr[$key]=$2
        commandIndArr+=("$key")
    }

    pc() {
        max_key_length=0
        pattern=$1

        if [[ -z $pattern ]]; then
        filteredCommands=$(print -l "${(@k)commandAccArr}")
        else
            filteredCommands=$(print -l "${(@k)commandTagArr[(R)*(^| )$pattern( |$)*]}")
        fi

        if [[ -z $filteredCommands ]]; then
            printf "\nNo commands with that pattern found\n\n"
            return
        fi

        declare -a orderedFilteredArr

        print "\n-------------------------------------Commands-------------------------------------"

        if [ -n "$ZSH_VERSION" ]; then        
            for i in ${commandIndArr}; do
                while IFS= read -r j; do
                    if [[ $i == $j ]]; then
                        orderedFilteredArr+=($j)
                    fi
                done <<< "${filteredCommands[@]}"``
            done   
        
            for key in ${orderedFilteredArr}; do
                if (( ${#key} > max_key_length )); then
                        max_key_length=${#key}
                fi
            done

            max_key_length=$((max_key_length + 5))
            line_number=1

            for key in ${orderedFilteredArr}; do
                printf "%-3s %-${max_key_length}s %s\n" "$line_number." "$key" "${commandAccArr[$key]}"
                ((line_number++))
            done
        else  
            for i in "${!commandIndArr[@]}"; do
                while IFS= read -r j; do
                    if [[ $i == $j ]]; then
                        orderedFilteredArr+=($j)
                    fi
                done <<< "${filteredCommands[@]}"``
            done     
            for key in "${!orderedFilteredArr[@]}"; do
                if (( ${#key} > max_key_length )); then
                        max_key_length=${#key}
                fi
            done        
            max_key_length=$((max_key_length + 5))
            line_number=1

            for key in "${!orderedFilteredArr[@]}"; do
                printf "%-3s %-${max_key_length}s %s\n" "$line_number." "$key" "${commandAccArr[$key]}"
                ((line_number++))
            done
        fi
        print
    }

    declare -a savedVars

    # Add variable to list of variables to be saved
    add_var(){
        savedVars+=($1)
    }

    # Save all of the variables in the list of variables to ~/.zshrc_vars
    save_vars() {
        echo -n "" > ~/.zshrc_vars.sh
        for var in "${savedVars[@]}"; do
            value="${(P)var}"
            echo "export $var=$value" >> ~/.zshrc_vars.sh
        done
    }

    # Load all of the variables in the list of variables saved from ~/.zshrc_vars
    load_vars(){
        source ~/.zshrc_vars.sh
    }

    # Output variables that are being saved when save_vars is called
    output_saved_vars() {
        for var in "${savedVars[@]}"; do
            echo "$var"
        done
    }

    documentCommand "resources" "development" "commands" "help" "pc" "Prints this command list, can filter by name or tag"
    documentCommand "vars" "variable" "config" "add_var" "Add variable to list of variables to be saved"
    documentCommand "vars" "variable" "save" "config" "save_vars" "Save all of the variables in the list of variables to ~/.zshrc_vars"
    documentCommand "vars" "variable" "load" "config" "load_vars" "Load all of the variables in the list of variables saved from ~/.zshrc_vars"
    documentCommand "vars" "variable" "save" "config" "output_saved_vars" "Output variables that are being saved when save_vars is called"
fi

shared_scripts_file_sourced=true