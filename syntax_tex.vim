" Vim Syntax File add vimlinknotes function
" Language:     VimLinkNotes
" Creator:      Benoit Hamelin <benoit.hamelin@gmail.com>
" Last Change:  2011 Dec 12 
"Mon Aug 18 20:01:05 CST 2014

syntax sync fromstart


"if version < 600
"  syn clear
"elseif exists("b:current_syntax")
"  finish
"endif

"syn keyword esp contained %%%
"syntax case match
" Original
"syntax match vimlinknotesTopic /+++[A-Za-z0-9_\.]\+\>/
"syntax match vimlinknotesDef   /^%%%[ \t]*[A-Za-z0-9_\.]\+\>/ contains=esp
"syntax match vimlinknotesHead /|||[A-Za-z0-9]\+\>.*/
"syntax match texDelimiter /%||[A-Za-z0-9]\+\>.*/ "could consider use texDelimiter group


"texTypeStyle: syntax color: yellow
"texDelimiter: syntax color: red
"texStatement: syntax color: bule green
"texNewEnv: syntax color: green
"syntax match texNewEnv /%||[A-Za-z0-9]\+\>.*/
"syntax match texStatement /%++[A-Za-z0-9_\.]\+\>/
"syntax match texDelimiter /^%%%[ \t]*[A-Za-z0-9_\.]\+\>/


"All colors
" http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
hi def greenTex guifg=#00af00 ctermfg=34
hi def orangeTex guifg=#af5f00 ctermfg=130
hi def magentaTex guifg=#870087 ctermfg=90
hi def blueTex guifg=#0087ff ctermfg=33
syntax cluster texFoldGroup add=greenTex,orangeTex,magentaTex,blueTex
syntax match greenTex /%||[A-Za-z0-9]\+\>.*/
syntax match orangeTex /%++[A-Za-z0-9_\.]\+\>/
syntax match magentaTex /^%%%[ \t]*[A-Za-z0-9_\.]\+\>/
syntax match blueTex /^%>>.*/

" topic and head match difference: topic as linking tags best as single words,
" and Head as defining search tags for ag, it's better to make multiple words
" searchable.
" I need to find a way to extract the content between delimit using ag ack.


"highlight default link vimlinknotesTopic Underlined
"highlight default link vimlinknotesDef   Statement
"highlight default link vimlinknotesHead  Underlined


"let b:current_syntax = "latex"

"syn sync maxlines=200
"syn sync minlines=50
