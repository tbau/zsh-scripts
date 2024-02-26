HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory

# Used by wsl (Windows Subsystem for Linux to gui applications)
# export DISPLAY="$(hostname).local:0"
# export QT_X11_NO_MITSHM=1
# export _X11_NO_MITSHM=1
# export _MITSHM=0

# Initialize nvm and pyenv
source ~/zsh-scripts/src/nvm/init-nvm.sh
source ~/zsh-scripts/src/pyenv/init-pyenv.sh

# Initialize auto loading of .nvmrc and .python-version files
source ~/zsh-scripts/src/nvm/auto-load-nvm.sh
source ~/zsh-scripts/src/pyenv/auto-load-pyenv.sh

# Initialize prompts
source ~/zsh-scripts/src/ip/ip-prompt.sh
source ~/zsh-scripts/src/git/git-prompt.sh
source ~/zsh-scripts/src/nvm/nvm-prompt.sh
source ~/zsh-scripts/src/pyenv/pyenv-prompt.sh

# Initialize prompt helpers for displaying prompts
source ~/zsh-scripts/src/prompt/load-prompts.sh

# Initalize shortcuts for git
source ~/zsh-scripts/src/git/git-scripts.sh

# Initalize shortcuts for directory commands
source ~/zsh-scripts/src/directory/directory-scripts.sh

# Initalize shortcuts for selenium
source ~/zsh-scripts/src/selenium/selenium-scripts.sh

# Initalize shortcuts for security commands
source ~/zsh-scripts/src/utility/security-scripts.sh

# Initalize shortcuts for resources for development
source ~/zsh-scripts/src/utility/dev-resource-scripts.sh

# Initalize shortcuts for utility commands
source ~/zsh-scripts/src/utility/utility-scripts.sh

# Sets the newline before and after the git prompt
git_prompt_set_newline 0 1
# Sets the newline before and after the nvm prompt
nvm_prompt_set_newline 0 1
# Sets the newline before and after the pyenv prompt
pyenv_prompt_set_newline 0 1
# Sets the newline before and after the whole block of prompts
# The first two arguments are for the newlines before and after
# The next two arguments are for the newlines before and after if no prompts are showing
display_prompt_set_newline 2 1 0 0

setopt PROMPT_SUBST

# Add prompts to precmd hooks to recalculate values for each prompt
# display_prompt_newline displays added prompts add the end of the prompt 
# display_prompt_newline must come after all other prompt functions
init_prompts ip_prompt git_prompt_newline nvm_prompt_newline pyenv_prompt_newline display_prompt_newline

PROMPT='%F{green}[%f%n@$IP_PROMPT %F{cyan}%~%F{green}]%f'

# Can add a newline to end of prompt, but better to set in in display_prompt_set_newline
# display_prompt_set_newline can handle when certain prompts are not shown
# push_end_prompt_newline

# Pushes prompt variables calculated in precmd hooks to be displayed in display_prompt_newline
push_end_prompt '$GIT_PROMPT'
push_end_prompt '$PYENV_PROMPT'
push_end_prompt '$NVM_PROMPT'

# Can add newlines to end of prompt, but better to set in in display_prompt_set_newline
# push_end_prompt_newline 

# Commits custom prompt to memory so it can be used to calculate end prompt of ever prompt calculation
# Also added $END_PROMPT to end of current prompt
set_end_prompt
PROMPT=$PROMPT'> '