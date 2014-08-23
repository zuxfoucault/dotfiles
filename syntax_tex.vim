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
syntax match vimlinknotesTopic /+++[A-Za-z0-9_\.]\+\>/
syntax match vimlinknotesDef   /^%%%[ \t]*[A-Za-z0-9_\.]\+\>/ contains=esp
syntax match vimlinknotesHead /^|||[A-Za-z0-9]\+\>.*/
" topic and head match difference: topic as linking tags best as single words,
" and Head as defining search tags for ag, it's better to make multiple words
" searchable.
" I need to find a way to extract the content between delimit using ag ack.


highlight default link vimlinknotesTopic Underlined
highlight default link vimlinknotesDef   Statement
highlight default link vimlinknotesHead   Underlined


"let b:current_syntax = "tex"

