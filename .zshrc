# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH:$HOME/.rvm/bin:/usr/texbin"

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

plugins=(git autojump)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export EDITOR="vim"
bindkey -v 


export KEYTIMEOUT=1 # kill the lag of transition between modes

# for tree coloring
export CLICOLOR=1
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'

function cdl {cd $1; lsa;}
#function pdfl {
#if [ "$#" -ne "0" ]
#   then
#   pdflatex ""$@".tex"
#   open ""$@".pdf"
#   fi
#}
function skim {open -a /Applications/Skim.app $1;}

alias lsa='ls -law'
alias lsu='ls -altuw'
alias vimnote='mvim `date +N%Y%m%d%H`'
#alias -g skim='-a /Applications/Skim.app'


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


