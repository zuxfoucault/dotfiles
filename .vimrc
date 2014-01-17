
" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

fun! EnsureVamIsOnDisk(plugin_root_dir)
  " windows users may want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, 7-zip and git tools first
  " -> BUG [4] (git-less installation)
  let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
  if isdirectory(vam_autoload_dir)
    return 1
  else
    if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
      " I'm sorry having to add this reminder. Eventually it'll pay off.
      call confirm("Remind yourself that most plugins ship with ".
                  \"documentation (README*, doc/*.txt). It is your ".
                  \"first source of knowledge. If you can't find ".
                  \"the info you're looking for in reasonable ".
                  \"time ask maintainers to improve documentation")
      call mkdir(a:plugin_root_dir, 'p')
      execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
                  \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
      " VAM runs helptags automatically when you install or update 
      " plugins
      exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
    endif
    return isdirectory(vam_autoload_dir)
  endif
endfun

fun! SetupVAM()
  " Set advanced options like this:
  " let g:vim_addon_manager = {}
  " let g:vim_addon_manager.key = value
  "     Pipe all output into a buffer which gets written to disk
  " let g:vim_addon_manager.log_to_buf =1

  " Example: drop git sources unless git is in PATH. Same plugins can
  " be installed from www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager.drop_git_sources = !executable('git')
  " let g:vim_addon_manager.debug_activation = 1

  " VAM install location:
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME/.vim/vim-addons', 1)
  if !EnsureVamIsOnDisk(c.plugin_root_dir)
  " old version
  "let plugin_root_dir = expand('$HOME/.vim/vim-addons')
  "if !EnsureVamIsOnDisk(plugin_root_dir)
    echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
    return
  endif
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  "let &rtp.=(empty(&rtp)?'':',').plugin_root_dir.'/vim-addon-manager'
  " 'powerline', 'AutomaticLaTeXPlugin' 
  " Tell VAM which plugins to fetch & load:
  call vam#ActivateAddons(['powerline', 'LaTeX-Suite_aka_Vim-LaTeX', 'ctrlp', 'Solarized', 'The_NERD_tree', 'python%790', 'vim-multiple-cursors', 'YouCompleteMe', 'Buffergator', 'fugitive', 'Screen_vim__gnu_screentmux', 'EasyMotion', 'Gundo' , 'yankstack', 'unimpaired'], {'auto_install' : 0})
  " sample: call vam#ActivateAddons(['pluginA','pluginB', 'LaTeX-Suite_aka_Vim-LaTeX' 'AutomaticLaTeXPlugin', 'Vim-R-plugin', 'Supertab', 'vim-online-thesaurus', ...], {'auto_install' : 0})
  " Also See "plugins-per-line" below

  " Addons are put into plugin_root_dir/plugin-name directory
  " unless those directories exist. Then they are activated.
  " Activating means adding addon dirs to rtp and do some additional
  " magic

  " How to find addon names?
  " - look up source from pool
  " - (<c-x><c-p> complete plugin names):
  " You can use name rewritings to point to sources:
  "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()

" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" on_ft: If Vim knows the filetype
" on_name: If Vim does not know about the filetype (eg if the plugin you
" want to load contains the ftdetect/* support code 
"let ft_addons = [
"	\ {'on_ft': '^\%(c\|cpp\)$', 'activate': [ 'plugin-for-c-development' ]},
"	\ {'on_ft': 'javascript', 'activate': [ 'plugin-for-javascript' ]},
"	\ {'on_name': '\.scad$', 'activate': [ 'plugin-for-javascript' ]}
"\ ]
"au FileType * for l in filter(copy(ft_addons), 'has_key(v:val, "on_ft") && '.string(expand('<amatch>')).' =~ v:val.on_ft') | call vam#ActivateAddons(l.activate, {'force_loading_plugins_now':1}) | endfor		
"au BufNewFile,BufRead * for l in filter(copy(ft_addons), 'has_key(v:val, "on_name") && '.string(expand('<amatch>')).' =~ v:val.on_name') | call vam#ActivateAddons(l.activate, {'force_loading_plugins_now':1}) | endfor

" Vim does not autodetect scad files, thus no filetype event gets
" triggered. BufNewFile and BufRead solve this, but they would not work
" for files without extension such as ".bashrc" which have filetype "sh"
" usually.

" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]

" System vimrc file for MacVim
" Maintainer:	Bjorn Winckler <bjorn.winckler@gmail.com>
" Last Change:	Sat Aug 29 2009

"29 set nocompatible
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
" noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

" powerline seeting !!!following 3 lines could be delete some day...
"let g:Powerline_symbols = 'fancy'
"set rtp+=~/.vim/vim-addons/powerline/powerline/bindings/vim
"set noshowmode
"set laststatus=2

" vim-latex setting
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
"let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_CompileRule_pdf = 'latexmk -synctex=1 -pdf -pvc $*'
"set iskeyword+=:

" ATP-setting
"let g:atp_tab_map = 1
"let g:atp_StatusLine=0

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

augroup CursorColumn
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
  au WinLeave * setlocal nocursorcolumn
augroup END

"set rtp+=~/.vim/vim-addons/vim-multiple-cursors
"let g:multi_cursor_use_default_mapping=0

set number  "activate line number
"set list    "show invisible characters
set shiftwidth=4
set tabstop=4
set splitbelow
set splitright
set spell spelllang=en_us

"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

"Max out the height of the current split
"ctrl + w _
"
"Max out the width of the current split
"ctrl + w |

"Normalize all split sizes, which is very handy when resizing terminal
"ctrl + w =

"Buffer and tab switching has never been that fast and easy.
"noremap <C-J> :bnext<CR>
"noremap <C-K> :bprev<CR>
noremap <C-J> <C-W>w
noremap <C-K> <C-W>p  
noremap <C-L> :tabn<CR>
noremap <C-H> :tabp<CR>
nnoremap ; :
nnoremap : ;

" Toggle Gundo
nnoremap <F2> :GundoToggle<CR>

" invoke EasyMotion <Leader><Leader>
map <F4> <Leader><Leader>
imap <F4> <ESC><Leader><Leader>

" invoke suggest words
imap <F3> <ESC>z= 

" yankstack: avoid <mete- > in vim terminal
if !has('gui_macvim')
nmap π <Plug>yankstack_substitute_older_paste
nmap ∏ <Plug>yankstack_substitute_newer_paste
"nmap <leader>p <Plug>yankstack_substitute_older_paste
"nmap <leader>P <Plug>yankstack_substitute_newer_paste
endif

"set timeout timeoutlen=3000 ttimeoutlen=100
set ttimeoutlen=100

if has('gui_macvim')
"set guifont==Monaco:h26
set guifont=Menlo\ Regular:h24

"MacVim: switch OSX windows with swipes
"nnoremap <silent> <SwipeLeft> :macaction _cycleWindowsBackwards:<CR>
"nnoremap <silent> <SwipeRight> :macaction _cycleWindows:<CR>
set guicursor+=a:blinkon0
set transparency=15
set guioptions-=r " Hide scrollbars
set macmeta
endif

setlocal foldmethod=marker

" auto-save while text changed
fun Aasa()
	autocmd TextChanged *
	\ if expand("%") != "" |
	\ update |
	\ endif
endfun

" Search options
" Ignore case when searching
set ignorecase
" Unless the search term has capital letters
set smartcase
" Global search and replace by default; use s/a/b/g to override
"set gdefault
" Start searching as soon as text is typed
set incsearch
" Jump back to matching bracket briefly when closing one is inserted. 
"set showmatch
" Highlight search results. Can be annoying, so
set hlsearch
" leader+space will clear it. 
nnoremap <leader><space> :noh<cr>

" Omni completion 
set omnifunc=syntaxcomplete#Complete
