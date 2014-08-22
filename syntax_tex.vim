" Vim Syntax File add vimlinknotes function
" Language:     VimLinkNotes
" Creator:      Benoit Hamelin <benoit.hamelin@gmail.com>
" Last Change:  2011 Dec 12 
"Mon Aug 18 20:01:05 CST 2014


"if version < 600
"  syn clear
"elseif exists("b:current_syntax")
"  finish
"endif

syn keyword esp contained %%%
syntax case match
syntax match vimlinknotesTopic /+++[A-Za-z0-9]\+\>/
syntax match vimlinknotesDef   /^%%[ \t]*[A-Za-z0-9]\+\>/ contains=esp

highlight default link vimlinknotesTopic Underlined
highlight default link vimlinknotesDef   Statement

"let b:current_syntax = "tex"

