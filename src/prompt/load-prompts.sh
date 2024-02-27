#!/bin/zsh

export SHOW_DEV_PROMPTS=1

display_end_prompt() {
    if [ "$SHOW_DEV_PROMPTS" = "1" ]; then
        END_PROMPT=$(print -P "$CUSTOM_END_PROMPT")
    else
        END_PROMPT=''
    fi
}

init_prompts() {
    for f in "$@"; do
        precmd_functions+=($f)
    done
}

clear_end_prompt() {
    CUSTOM_END_PROMPT=''
}

push_end_prompt_newline() {
    CUSTOM_END_PROMPT=$CUSTOM_END_PROMPT$'%{\n\r%}'
}

push_end_prompt() {
    CUSTOM_END_PROMPT=$CUSTOM_END_PROMPT$1
}

set_end_prompt() {
    CUSTOM_END_PROMPT=$CUSTOM_END_PROMPT$'%{\n%}'
    PROMPT=$PROMPT'$END_PROMPT'
}

#Hide Dev Prompt
hdp() {
    SHOW_DEV_PROMPTS=0
    save_vars
}

#Show Dev Prompt
sdp() {
    SHOW_DEV_PROMPTS=1
    save_vars
}

save_vars() {
    echo "export SHOW_DEV_PROMPTS=$SHOW_DEV_PROMPTS" >~/.zshrc_vars
    echo "export SHOW_IP=$SHOW_IP" >>~/.zshrc_vars
}

display_prompt_set_newline() {
    end_prompt_newlines_before=$1
    end_prompt_newlines_after=$2
    end_prompt_newlines_before_no_prompts=$3
    end_prompt_newlines_after_no_prompts=$4   
}

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
    else;
        for i in $(seq 1 $countBefore); do
            newLinesBefore=$newLinesBefore$'%{\n\r%}'
        done
        for j in $(seq 1 $countAfter); do
            newLinesAfter=$newLinesAfter$'%{\n\r%}'
        done
    fi

   END_PROMPT=$newLinesBefore$END_PROMPT$newLinesAfter
}

source ~/.zshrc_vars
CUSTOM_END_PROMPT=''
