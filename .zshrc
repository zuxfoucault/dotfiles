# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

#export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH:$HOME/.rvm/bin:/usr/texbin:$HOME/playGround/shCollection"
export PATH="/usr/local/bin:$PATH:$HOME/.rvm/bin:/usr/texbin:$HOME/playGround/shCollection"
export TERM="xterm-256color-italic"

#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="at0915"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

#autoload -U compinit && compinit -u # autojump tab completion non-security

##Uncomment following line if you want to disable command autocorrection
#DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you don't want greedy autocomplete
setopt MENU_COMPLETE

plugins=(git git-extras history-substring-search fasd tmux osx vi-mode python zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/opp.zsh/opp.zsh
source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/opp.zsh/opp/*.zsh



# Customize to your needs...
export EDITOR="vim"
#bindkey -v


export KEYTIMEOUT=1 # kill the lag of transition between modes

# for tree coloring
export CLICOLOR=1
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'

function cdl {cd $1; l;}
#function pdfl {
#if [ "$#" -ne "0" ]
#   then
#   pdflatex ""$@".tex"
#   open ""$@".pdf"
#   fi
#}
function skim {open -a /Applications/Skim.app $1;}

alias l='ls -law'
alias lu='ls -altuw'
alias vimnote='mvim `date +N%Y%m%d%H%M%S`.tex'
#alias -g skim='-a /Applications/Skim.app'
alias ag='ag -S'
alias v='f -e mvim'
#alias v='f -t -e mvim -b ~/.viminfo'

#typeset -A abbreviations
#abbreviations=(
#	"skim" "-a /Applications/Skim.app"
#)
#
#magic-abbrev-expand() {
#    local MATCH
#    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
#    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
#    zle self-insert
#}
#
#no-magic-abbrev-expand() {
#  LBUFFER+=' '
#}
#
#zle -N magic-abbrev-expand
#zle -N no-magic-abbrev-expand
#bindkey " " magic-abbrev-expand
#bindkey "^x " no-magic-abbrev-expand # couldn't work. ^x char issue
#bindkey -M isearch " " self-insert


# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export LC_CTYPE="en_US.UTF-8"

## Use modern completion system
#autoload -Uz compinit
#compinit

#zstyle ':completion:*' auto-description 'specify: %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true
#
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#autoload predict-on
#predict-on

# Setupzsh-history-substring-search
source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


## Setup zsh-autosuggestions
#source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/zsh-autosuggestions/autosuggestions.zsh
#
## Enable autosuggestions automatically
#zle-line-init() {
#    zle autosuggest-start
#}
#zle -N zle-line-init
#
## use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
## zsh-autosuggestions is designed to be unobtrusive)
#bindkey '^T' autosuggest-toggle
#bindkey '^f' vi-forward-blank-word
