
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
  call vam#ActivateAddons(['powerline', 'LaTeX-Suite_aka_Vim-LaTeX', 'ctrlp', 'Solarized', 'The_NERD_tree', 'vim-multiple-cursors', 'YouCompleteMe', 'Buffergator', 'fugitive', 'Screen_vim__gnu_screentmux', 'EasyMotion', 'Gundo' , 'yankstack', 'Syntastic','UltiSnips', 'Python-mode-klen', 'unimpaired', 'Tagbar', 'ack', 'surround', 'Vim-R-plugin', 'easytags', 'vim-misc'], {'auto_install' : 1})
  " sample: call vam#ActivateAddons(['pluginA','pluginB', 'LaTeX-Suite_aka_Vim-LaTeX' 'AutomaticLaTeXPlugin', 'Vim-R-plugin', 'Supertab', 'vim-online-thesaurus', 'python%790'...], {'auto_install' : 0})
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

" powerline setting !!!following 3 lines could be delete some day...
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

" Ack.vim setting, using Ag
nnoremap <silent><Leader>a :Ack!<space>
let g:ackprg = 'ag --smart-case --nogroup --nocolor --column'
"" Ack motions {{{
"" Motions to Ack for things.  Works with pretty much everything, including:
""   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
"" Awesome.
"" Note: If the text covered by a motion contains a newline it won't work.  Ack
"" searches line-by-line.
"
"nnoremap <silent> <leader>A :set opfunc=<SID>AckMotion<CR>g@
"xnoremap <silent> <leader>A :<C-U>call <SID>AckMotion(visualmode())<CR>
"
"nnoremap <bs> :Ack! '\b<c-r><c-w>\b'<cr>
"xnoremap <silent> <bs> :<C-U>call <SID>AckMotion(visualmode())<CR>
"
"function! s:CopyMotionForType(type)
"    if a:type ==# 'v'
"        silent execute "normal! `<" . a:type . "`>y"
"    elseif a:type ==# 'char'
"        silent execute "normal! `[v`]y"
"    endif
"endfunction
"
"function! s:AckMotion(type) abort
"    let reg_save = @@
"    call s:CopyMotionForType(a:type)
"    execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"
"    let @@ = reg_save
"endfunction
"" }}}

"let g:multi_cursor_use_default_mapping=0

set number  "activate line number
set list    "show invisible characters
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
"set showbreak=↪
set shiftwidth=4
set tabstop=4
set splitbelow
set splitright
set spell spelllang=en_us

" easytags setting
" write to the first existing tags file seen by Vim
"set tags=./tags;
"let g:easytags_dynamic_files = 1
let g:easytags_ignored_filetypes = '^vim$'

" Fugitive setting
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" }}} test {{{
" Trailing whitespace
" Only shown when not in insert mode.
augroup trailing
	au!
	au InsertEnter * :set listchars-=trail:⌴
	au InsertLeave * :set listchars+=trail:⌴
augroup END

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

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END


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
"noremap <C-J> <C-W>w
"noremap <C-K> <C-W>p
"noremap <C-L> :tabn<CR>
"noremap <C-H> :tabp<CR>
nnoremap ; :
nnoremap : ;
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap H ^
noremap L $
vnoremap L g_
nnoremap <C-Left> 5<C-W><
nnoremap <C-Right> 5<C-W>>
inoremap <C-a> <ESC>A

" Open a Quickfix window for the last search.
nnoremap <silent><Leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Switching to the previously edited buffer "or :b#
noremap <F10> <C-^>

" Ack for last search
"nnoremap <silent><Leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Clean trailing whitespace
"nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" map Ω"Focus" the current line.  Basically: {{{
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.  My eyes are bad.
" This mapping wipes out the z mark, which I never use.
" I use :sus for the rare times I want to actually background Vim.

if !has('gui_macvim')
	"nnoremap Ω  mzzMzvzz1<c-e>`z:Pulse<cr>
	nnoremap Ω  mzzMzvzz`z:Pulse<cr>
else
	"nnoremap <M-z> mzzMzvzz1<c-e>`z:Pulse<cr>
	nnoremap <M-z> mzzMzvzz`z:Pulse<cr>
endif

" Pulse Line {{{
function! s:Pulse() " {{{
    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    let steps = 8
    let width = 1
    let start = width
    let end = steps * width
    let color = 233

    for i in range(start, end, width)
        execute "hi CursorLine ctermbg=" . (color + i)
        redraw
        sleep 6m
    endfor
    for i in range(end, start, -1 * width)
        execute "hi CursorLine ctermbg=" . (color + i)
        redraw
        sleep 6m
    endfor

    execute 'hi ' . old_hi
endfunction " }}}
command! -nargs=0 Pulse call s:Pulse()
" }}}

"}}}

" Toggle Gundo
nnoremap <F2> :GundoToggle<CR>

"NERD Tree\
nnoremap  <F6> :NERDTreeToggle<cr>

" Tagbar
nnoremap <F8> :TagbarToggle<CR>

"Syntastic
noremap <F1> :SyntasticReset<CR>
inoremap <F1> <ESC>:SyntasticReset<CR>

" invoke EasyMotion <Leader><Leader>
map <F4> <Leader><Leader>
imap <F4> <ESC><Leader><Leader>

" Vim-R-plugin
let r_syntax_folding = 1

" invoke suggest words
inoremap <F3> <ESC>z=

" avoid key map conflict between py-mode and buffergator
let g:pymode_breakpoint_bind = '<leader><leader>b'
"let g:pymode_rope = 0
"let g:pymode_rope_completion = 0
"let g:pymode_lint = 0
"let g:pymode_virtualenv = 0
"let g:pymode_python = 'python' #set Python version, however virtualenv supported
"let g:pymode_rope_completion_bind = '<C-Space>m'

" YCM
let g:ycm_path_to_python_interpreter = '/usr/bin/python'


" yankstack: avoid <mete- > in vim terminal
if !has('gui_macvim')
nmap π <Plug>yankstack_substitute_older_paste
nmap ∏ <Plug>yankstack_substitute_newer_paste
"nmap <leader>p <Plug>yankstack_substitute_older_paste
"nmap <leader>P <Plug>yankstack_substitute_newer_paste
highlight Comment cterm=italic
endif

"set timeout timeoutlen=3000 ttimeoutlen=100
set ttimeoutlen=100

if has('gui_macvim')
"set guifont==Monaco:h26
"set guifont=Menlo\ Regular:h24
"set guifont=Consolas:h28
set guifont=Anonymous\ Pro:h28

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
	autocmd TextChanged,InsertLeave *
	\ if expand("%") != "" |
	\ update |
	\ endif
	
"	autocmd TextChangedI *
"	\ if expand("%") != "" |
"	\ update |
"	\ endif
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
set showmatch
set matchtime=1 "default = 5 
" Highlight search results. Can be annoying, so
set hlsearch
" leader+space will clear it. 
nnoremap <leader><space> :noh<cr>
" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv
" Omni completion 
set omnifunc=syntaxcomplete#Complete

set tags+=tags

" Highlight Word {{{
" This mini-plugin provides a few mappings for highlighting words temporarily.
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.
" Mappings {{{
nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>
" }}}

function! HiInterestingWord(n) "{{{
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction
" }}}

" Default Highlights {{{
hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195
" }}}
" }}}

" resolve for YCM and UltiSnips conflicts {{{
"function! g:UltiSnips_Complete()
"    call UltiSnips_ExpandSnippet()
"    if g:ulti_expand_res == 0
"        if pumvisible()
"            return "\<C-n>"
"        else
"            call UltiSnips_JumpForwards()
"            if g:ulti_jump_forwards_res == 0
"               return "\<TAB>"
"            endif
"        endif
"    endif
"    return ""
"endfunction
"
"au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-e>"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
"let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" avoid vim latex conflict with UltiSnips
"imap <C-f> <Plug>IMAP_JumpForward
"}}}


" Add the virtualenv's site-packages to vim path {{{
"py << EOF
"import os.path
"import sys
"import vim
"if 'VIRTUAL_ENV' in os.environ:
"    project_base_dir = os.environ['VIRTUAL_ENV']
"    sys.path.insert(0, project_base_dir)
"    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"    execfile(activate_this, dict(__file__=activate_this))
"EOF
" }}}
