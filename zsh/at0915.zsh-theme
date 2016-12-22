# https://github.com/syl20bnr/syl20bnr-zsh-theme/blob/master/syl20bnr.zsh-theme

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color

# Format for git_prompt_info()
#ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[magenta]%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[magenta]%}"  #ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"  #ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for parse_git_dirty()
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
#ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Format for git_prompt_status()
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$RED%}unmerged"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$RED%}deleted"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$YELLOW%}renamed"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$YELLOW%}modified"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$GREEN%}added"
#ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$WHITE%}untracked"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$YELLOW%}untracked"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$RED%}!!"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$YELLOW%}[%{$YELLOW%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$YELLOW%}]"

# Format for VI mode
# INSERT_MODE="%{$GREEN%}-- INSERT -- "
# NORMAL_MODE="%{$RED%}-- NORMAL -- "
INSERT_MODE="%{$GREEN%}➤"
NORMAL_MODE="%{$RED%}⨯"
#VI_PROMPT="$NORMAL_MODE"
function zle-keymap-select zle-line-finish {
  VI_PROMPT="${${KEYMAP/vicmd/$NORMAL_MODE}/(main|viins)/$INSERT_MODE}"
  zle reset-prompt
  zle -R
}

zle-line-init() { zle -K viins; }
zle -N zle-line-init
zle -N zle-keymap-select

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}


local return_status="%{$fg[red]%}%(?,,⤬)%{$reset_color%}"
#RPROMPT='${return_status}%{$reset_color%}'
RPROMPT='%{$fg_bold[red]%}%* ${return_status}%{$reset_color%}' 

PROMPT='%{$fg_bold[magenta]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info) %{$GREEN_BOLD%}$(git_prompt_short_sha)$(git_prompt_status)%{$RESET_COLOR%}\
$(virtualenv_info)%(?,,%{$fg_bold[green]%}[%?]%{$reset_color%}) 
$VI_PROMPT%{$RESET_COLOR%}$ '

# comment at APR1
#PROMPT='${return_status}%{$reset_color%}
#%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%* %{$fg_bold[magenta]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)\
#$(virtualenv_info)%(?,,%{$fg_bold[green]%}[%?]%{$reset_color%}) $ '


