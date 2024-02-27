#!/bin/zsh
# This script defines a function for generating a prompt
# of the format git(branch) that can be included in a custom prompt
# The prompt includes a # if the branch is clean and a ! if it is dirty

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:git*' formats '%b'

# You can access the prompt generated by this script with the GIT_PROMPT env variable
# Exported variables
#   GIT_BRANCH: Branch name only
#   GIT_PROMPT: Custom git prompt with dirty status
git_prompt() {
    is_dirty() {
        test -n "$(git status --porcelain --ignore-submodules)"
    }
    vcs_info
    export GIT_BRANCH="$vcs_info_msg_0_"
    GIT_PROMPT=$GIT_BRANCH
    if [[ -n "$GIT_PROMPT" ]]; then
        GIT_PROMPT="%F{cyan}[${GIT_PROMPT}]%f"
        if is_dirty; then
            GIT_PROMPT="%F{yellow}%B!%b%f${GIT_PROMPT}"
        else
            GIT_PROMPT="%F{green}%B#%b%f${GIT_PROMPT}"
        fi
        GIT_PROMPT='git('$GIT_PROMPT')'
    else
        GIT_PROMPT=''
    fi
}

git_prompt_set_newline() {
    git_prompt_newlines_before=$1
    git_prompt_newlines_after=$2
}

git_prompt_newline() {
    git_prompt

    local countBefore=$git_prompt_newlines_before
    local countAfter=$git_prompt_newlines_after
    newLinesBefore=""
    newLinesAfter=""

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

    if [ -n "$GIT_PROMPT" ]; then
        GIT_PROMPT=$newLinesBefore$GIT_PROMPT$newLinesAfter
    fi
}