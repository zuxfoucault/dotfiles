" System vimrc file for MacVim
"
" Maintainer:	Bjorn Winckler <bjorn.winckler@gmail.com>
" Last Change:	Sat Aug 29 2009

set nocompatible
set laststatus=2   " Always show the statusline 1210
set encoding=utf-8 " Necessary to show Unicode glyphs 1210
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors 1210

" The default for 'backspace' is very confusing to new users, so change it to a
" more sensible value.  Add "set backspace&" to your ~/.vimrc to reset it.
set backspace+=indent,eol,start

" Disable localized menus for now since only some items are translated (e.g.
" the entire MacVim menu is set up in a nib file which currently only is
" translated to English).
set langmenu=none

syntax enable
let g:solarized_termtrans = 1
colorscheme solarized
"togglebg#map("<F5>") 

" Yank text to the OS X clipboard
noremap <leader>y "*y
noremap <leader>yy "*Y

" Preserve indentation while pasting text from the OS X clipboard
noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

"Pathogen setting
call pathogen#infect('bundle')
filetype plugin indent on

