#!/usr/local/bin/zsh

osascript -e \
'on run argv
    tell application "System Events"
        set old_frontmost to item 1 of (get name of processes whose frontmost is true)
    end tell
    tell application "iTerm"
        activate
        set myterm to (make new terminal)
        # set number of columns of myterm to 250
        # set number of rows of myterm to 30
        tell myterm
            set mysession to (make new session at the end of sessions)
            tell mysession
                exec command "env PATH=/usr/local/bin/:$PATH /usr/local/bin/zsh -f"
                write text "cd " & quoted form of (item 2 of argv)
                write text (item 1 of argv) & " && exit"
            end tell
            repeat while (exists myterm)
                delay 0.1
            end repeat
        end tell
    end tell
    tell application old_frontmost
        activate
    end tell
end run' $1 $PWD


#!/bin/bash

# update for iterm2 3.0+

#osascript -e \
#$'on run argv
#    tell application "System Events"
#        set old_frontmost to item 1 of (get name of processes whose frontmost is true)
#    end tell
#    tell application "iTerm2"
#        set myterm to (create window with default profile)
#        tell myterm
#          select
#        end
#        tell current session of myterm
#            write text "cd " & quoted form of (item 2 of argv)
#            write text "bash -c \'" & (item 1 of argv) & " && exit\'"
#        end tell
#        repeat while (exists myterm)
#            delay 0.1
#        end repeat
#    end tell
#    tell application old_frontmost
#        activate
#    end tell
#end run' "$1" "$PWD"

#osascript -l JavaScript /path/to/fzf_MacVim.scpt "$1" $PWD
