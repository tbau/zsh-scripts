#/bin/bash
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

printCommands() {
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