#!/bin/zsh

if [[ -z "$load_prompts_file_sourced" ]]; then

    export SHOW_DEV_PROMPTS=true
    export CUSTOM_END_PROMPT=''

    # Displays End Prompt
    display_end_prompt() {
        if [ "$SHOW_DEV_PROMPTS" = true ]; then
            END_PROMPT=$(print -P "$CUSTOM_END_PROMPT")
        else
            END_PROMPT=''
        fi
    }

    # Add prompts to precmd hooks to recalculate values for each prompt
    init_prompts() {
        for f in "$@"; do
            precmd_functions+=($f)
        done
    }

    # Resets the Custom End Prompt
    clear_end_prompt() {
        CUSTOM_END_PROMPT=''
    }
    
    # Pushes prompt variables calculated in precmd hooks to be displayed in display_prompt_newline
    push_end_prompt_newline() {
        CUSTOM_END_PROMPT=$CUSTOM_END_PROMPT$'%{\n\r%}'
    }

    # Pushes prompt variables calculated in precmd hooks to be displayed in display_prompt_newline
    push_end_prompt() {
        CUSTOM_END_PROMPT=$CUSTOM_END_PROMPT$1
    }

    # Commits custom prompt to memory so it can be used to calculate end prompt for every prompt calculation
    # Also adds $END_PROMPT to end of current prompt
    set_end_prompt() {
        CUSTOM_END_PROMPT=$CUSTOM_END_PROMPT$'%{\n%}'
        PROMPT=$PROMPT'$END_PROMPT'
    }

    #Hide Dev Prompts
    hdp() {
        SHOW_DEV_PROMPTS=false
        save_vars
    }

    #Show Dev Prompts
    sdp() {
        SHOW_DEV_PROMPTS=true
        save_vars
    }

    # Sets the newlines before and after End Prompt
    # Required to se called before using display_prompt_newline
    display_prompt_set_newline() {
        end_prompt_newlines_before=$1
        end_prompt_newlines_after=$2
        end_prompt_newlines_before_no_prompts=$3
        end_prompt_newlines_after_no_prompts=$4   
    }

    # Displays End Prompt but adds newlines before and after it
    display_prompt_newline() {    
        display_end_prompt

        local countBefore=$end_prompt_newlines_before
        local countAfter=$end_prompt_newlines_after
        newLinesBefore=""
        newLinesAfter=""
    
        if [ -z "$END_PROMPT" ]; then
            countBefore=$end_prompt_newlines_before_no_prompts
            countAfter=$end_prompt_newlines_after_no_prompts
        fi

        if [[ "$OSTYPE" == "darwin"* ]]; then
            if (($countBefore > 0)); then
                for i in $(seq 1 $countBefore); do
                    newLinesBefore=$newLinesBefore$'%{\n%}'
                done           
            fi        
            if (($countAfter > 0)); then
                for j in $(seq 1 $countAfter); do
                    newLinesAfter=$newLinesAfter$'%{\n%}'
                done
            fi
        else
            for i in $(seq 1 $countBefore); do
                newLinesBefore=$newLinesBefore$'%{\n\r%}'
            done
            for j in $(seq 1 $countAfter); do
                newLinesAfter=$newLinesAfter$'%{\n\r%}'
            done
        fi

        END_PROMPT=$newLinesBefore$END_PROMPT$newLinesAfter
    }

    # Used to setup pathing
    # Do not remove or script will not know how to find other scripts
    declare -A zsh_scripts_directories
    if [ -n "$ZSH_VERSION" ]; then
        zsh_scripts_directories["prompt_dir"]=$(dirname "${(%):-%x}")
    elif [ -n "$BASH_VERSION" ]; then
        zsh_scripts_directories["prompt_dir"]=$(dirname "${BASH_SOURCE[0]}")
    fi

    source "$(dirname "${zsh_scripts_directories["prompt_dir"]}")/shared/shared-scripts.sh"
    add_var "SHOW_DEV_PROMPTS"
    load_vars
fi

load_prompts_file_sourced=true