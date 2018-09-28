# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

#export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH:$HOME/.rvm/bin:/usr/texbin:$HOME/playGround/shCollection"
export PATH="/usr/local/bin:$PATH:$HOME/.rvm/bin:/Volumes/SSD/Space/playGround/shCollection"
#export TERM="xterm-256color-italic"
export TERM="xterm-256color"

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
#COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you don't want greedy autocomplete
setopt MENU_COMPLETE

plugins=(git git-extras wd fasd osx vi-mode python history-substring-search colorize colored-man-pages_mod zsh-autosuggestions zsh-syntax-highlighting)


source $ZSH/oh-my-zsh.sh
source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/opp.zsh/opp.zsh
source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/opp.zsh/opp/*.zsh



# Customize to your needs...
#export EDITOR="vim"
# for ftags
export EDITOR=mvim
#bindkey -v


export KEYTIMEOUT=1 # kill the lag of transition between modes

# for tree coloring
export CLICOLOR=1
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'

function cl() {cd $1; l;}
#function pdfl() {
#if [ "$#" -ne "0" ]
#   then
#   pdflatex ""$@".tex"
#   open ""$@".pdf"
#   fi
#}
function skim() {open -a /Applications/Skim.app $1;}

# easier for change directory and list
unalias z
function z() {fasd_cd -d $1; l;} #can't work
unalias zz
function zz() {fasd_cd -d -i $1; l;}

alias l='ls -lawtr'
alias lu='ls -altuw'
alias vimnote='mvim `date +N%Y%m%d%H%M%S`.tex'
alias m='mvim `date +N%Y%m%d`000000.tex'
#alias vimnote='mvim `date +N%Y%m%d%H%M%S`.md'
#alias vimdate='mvim `date +N%Y%m%d`000000.md'
alias vimvo='mvim `date +V%Y%m%d`000000.tex'
#alias -g skim='-a /Applications/Skim.app'
#alias ag='ag -S'
alias ag='rg -S'
#alias vv='f -e mvim'
alias v='LC_CTYPE=C LANG=C f -t -i -e mvim -b viminfo'
alias vv='LC_CTYPE=C LANG=C f -t -i -e vim -b viminfo'
#alias v='f -t -i -e mvim -b viminfo'
#unalias v
#function v() {export LC_CTYPE=C LANG=C; f -t -e mvim -b viminfo $1; unset LC_CTYPE=C LANG=C} #can't work
alias mm='mvim'
alias mynetcon='sudo lsof -n -P -i +c 15'
alias tt='open -a TexShop'
alias mkmk='mkdir `date +R%Y%m%d`'
alias mkm='mkdir `date +%Y%m%d`'
alias todos='ag "todo"'
alias mtodos='mm /Volumes/SSD/googleDrive/papers/texNote/journal/todos.tex'

# For tmux
#alias tmn='tmux new -s $(basename $(pwd))'
#alias tma='tmux attach -d -t'
#alias tml='tmux list-sessions'
# Adopt form oh-my-zsh
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'


# Homemade Growl
alias growl='echo iterm2done'

# LESS; Enable syntax-highlighting in less.
#LESSPIPE=`which src-hilite-lesspipe.sh`
#export LESSOPEN="| ${LESSPIPE} %s"
export LESSOPEN="| source-highlight -f esc-solarized --style-file=esc-solarized.style -i %s -o STDOUT"
export LESS='-R -X -F -PmL\:%lt-%lb/%L(%Pt-%Pb\%) B\:%bt-%bb(%pt-%pb\%)/%B F\:%f'
alias le='less -m -N -g -i -J --underline-special --SILENT'


# MacOS quick look
alias ql='qlmanage -p'


# turbovnc_bcc
alias turbovnc_bcc='ssh -L 5901:localhost:5901 bc@10.20.12.240'
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


# Task Completion Notification
function f_notifyme {
  LAST_EXIT_CODE=$?
  CMD=$(fc -ln -1)
  # No point in waiting for the command to complete
  notifyme.sh "$CMD" "$LAST_EXIT_CODE" &
}
export PS1='$(f_notifyme)'$PS1


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export LC_CTYPE="en_US.UTF-8"

## Use modern completion system (to 156) not good
## will change previous modified string
#autoload -Uz compinit
#compinit
#
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
#
#autoload predict-on
#predict-on

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
#source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Setupzsh-history-substring-search
#source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Setup zsh-autosuggestions
#source /Users/zuxfoucault/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
bindkey '^F' autosuggest-clear
bindkey '^j' autosuggest-accept
bindkey '^f' vi-forward-blank-word
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=34"
#AUTOSUGGESTION_HIGHLIGHT_COLOR="fg=34"
#AUTOSUGGESTION_HIGHLIGHT_COLOR="fg=24" or 28
eval "$(rbenv init -)"

#alias matlab='LANG="en_US.UTF-8" && /Applications/MATLAB_R2012b.app/bin/matlab'

# Easier to update
#alias gg='scp -rv /Volumes/SSD/Space/playGround/meg/src_mne zuxfoucault@hpc.psy.ntu.edu.tw:/home/zuxfoucault/space/'

#alias cn4='mosh hpc.psy.ntu.edu.tw -- ssh cn4'

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
#source ~/.iterm2_shell_integration.`basename $SHELL`

# Login shell Tmux
#[[ $- != *i* ]] && return¬
#[[ -z "$TMUX" ]] && exec tmux new-session


# setup java home
export  JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/"

# added by Miniconda3 4.3.21 installer
export PATH="/Volumes/SSD/Space/miniconda3/bin:$PATH"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--reverse --inline-info"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'
alias fzfpreview="fzf --preview '[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -500'"
#export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# fzf alt-c
#bindkey '^X^T' fzf-file-widget
#bindkey '^T' transpose-chars

# ftags - search ctags
# https://github.com/junegunn/fzf/wiki/examples
ftags() {
  local line
  [ -e /Users/zuxfoucault/dotfiles/vimtags/latex ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' /Users/zuxfoucault/dotfiles/vimtags/latex |
    cut -c1-80 | fzf --nth=1,2
  ) && ${EDITOR:-vim} $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}

# Search for academic PDFs by author, title, journal, institution
p () {
    local DIR open
    declare -A already
    DIR="${HOME}/.cache/pdftotext"
    mkdir -p "${DIR}"
    if [ "$(uname)" = "Darwin" ]; then
        open=open
    else
        open="gio open"
    fi

    {
    ag -g ".pdf$"; # fast, without pdftotext
    ag -g ".pdf$" \
    | while read -r FILE; do
        local EXPIRY HASH CACHE
        HASH=$(md5sum "$FILE" | cut -c 1-32)
        # Remove duplicates (file that has same hash as already seen file)
        [ ${already[$HASH]+abc} ] && continue # see https://stackoverflow.com/a/13221491
        already[$HASH]=$HASH
        EXPIRY=$(( 86400 + $RANDOM * 20 )) # 1 day (86400 seconds) plus some random
        CMD="pdftotext -f 1 -l 1 '$FILE' - 2>/dev/null | tr \"\n\" \"_\" "
        CACHE="$DIR/$HASH"
        test -f "${CACHE}" && [ $(expr $(date +%s) - $(date -r "$CACHE" +%s)) -le $EXPIRY ] || eval "$CMD" > "${CACHE}"
        echo -e "$FILE\t$(cat ${CACHE})"
    done
    } | fzf -e  -d '\t' \
        --preview-window up:75% \
        --preview '
                v=$(echo {q} | tr " " "|");
                echo {1} | grep -E "^|$v" -i --color=always;
                pdftotext -f 1 -l 1 {1} - | grep -E "^|$v" -i --color=always' \
        | awk 'BEGIN {FS="\t"; OFS="\t"}; {print "\""$1"\""}' \
        | xargs $open > /dev/null 2> /dev/null
}

