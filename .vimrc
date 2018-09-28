
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
  call vam#ActivateAddons(['powerline', 'LaTeX-Suite_aka_Vim-LaTeX', 'ctrlp', 'Solarized', 'The_NERD_tree', 'vim-visual-multi', 'YouCompleteMe', 'Buffergator', 'fugitive', 'Screen_vim__gnu_screentmux', 'EasyMotion', 'Gundo' , 'yankstack', 'Syntastic','UltiSnips', 'vim-snippets', 'Python-mode-klen', 'jedi-vim', 'virtualenv', 'unimpaired', 'Tagbar', 'ack', 'surround', 'easytags', 'vim-misc', 'autocorrect', 'goyo', 'vim-textobj-quote', 'textobj-user', 'vim-lexical', 'limelight', 'vim-textobj-sentence', 'vim-wordy', 'MatlabFilesEdition', 'Tabular', 'thesaurus_query', 'indentLine', 'vim-signature', 'vim-expand-region', 'ALE_-_Asynchronous_Lint_Engine', 'vim-easy-align', 'vim-pandoc', 'vim-pandoc-syntax', 'fzf-vim', 'fzf-preview', 'neomru', 'Crunch', 'vim-gitgutter',], {'auto_install' : 1})

" sample: call vam#ActivateAddons(['pluginA','pluginB', , 'LaTeX-Suite_aka_Vim-LaTeX' 'AutomaticLaTeXPlugin', 'Vim-R-plugin', 'Supertab', 'vim-online-thesaurus', 'Indent_Guides', 'python%790'...], {'auto_install' : 0})
" some interesting and useful plugins: editorconfig-vim eg. indentation space
" or tab
" vim-gitgutter: git diff in the gutter

" need self-updated: 'vim-lexical', 'limelight', 'vim-textobj-sentence', 'vim-wordy'

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
set laststatus=2   " Always show the statusline 1210l
set showcmd " show information about how the current command going on
set encoding=utf-8 " Necessary to show Unicode glyphs 1210
set fillchars+=stl:\ ,stlnc:\
if !has('gui_macvim')
	set term=xterm-256color
	set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors 1210
	set t_AB=[48;5;%dm
	set t_AF=[38;5;%dm
	set mouse=a
endif
set termencoding=utf-8

set wildmenu
set wildmode=list:longest,full
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" The default for 'backspace' is very confusing to new users, so change it to a
" more sensible value.  Add "set backspace&" to your ~/.vimrc to reset it.
set backspace+=indent,eol,start

" Disable localized menus for now since only some items are translated (e.g.
" the entire MacVim menu is set up in a nib file which currently only is
" translated to English).
set langmenu=none

syntax enable

"Solarized color
let g:solarized_termtrans = 1
colorscheme solarized
"togglebg#map("<F5>") 
set background=dark

"leader mapping
"let mapleader = "\<Space>"

" remap ESC
"inoremap ii <Esc>

" Preserve indentation while pasting text from the OS X clipboard
" noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

" powerline setting !!!following 3 lines could be delete some day...
"let g:powerline_pycmd="python3"
"let g:powerline_pyeval="python3"
"let g:powerline_pyeval="/usr/local/bin/python3"
"let g:powerline_pyeval="/Volumes/SSD/Space/miniconda3/bin/python3"
"let g:Powerline_symbols = 'fancy'
"set rtp+=~/.vim/vim-addons/powerline/powerline/bindings/vim
"set noshowmode
"set laststatus=2

" vim-latex setting
"set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
"let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_CompileRule_pdf = 'latexmk -synctex=1 -pdf -pvc $*'
"set iskeyword+=:

" ATP-setting
"let g:atp_tab_map = 1
"let g:atp_StatusLine=0

" ALE setting
let g:ale_emit_conflict_warnings = 0

" Ack.vim setting, using Ag
let g:ackprg = 'ag --smart-case --nogroup --nocolor --column'
" Ack motions {{{
" Motions to Ack for things.  Works with pretty much everything, including:
"   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
" Awesome.
" Note: If the text covered by a motion contains a newline it won't work.  Ack
" searches line-by-line.

"nnoremap <silent><leader>a :set opfunc=<SID>AckMotion<CR>g@
"xnoremap <silent> <leader>A :<C-U>call <SID>AckMotion(visualmode())<CR>

nnoremap <silent><leader>a :Ack! '\b<c-r><c-w>\b'<cr>
"nnoremap <bs> :Ack! '\b<c-r><c-w>\b'<cr>
nnoremap <bs> :Ack! <c-r><c-w><cr>
xnoremap <silent> <bs> :<C-U>call <SID>AckMotion(visualmode())<CR>
nnoremap <silent><Leader>A :Ack!<space>

function! s:CopyMotionForType(type)
    if a:type ==# 'v'
        silent execute "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'char'
        silent execute "normal! `[v`]y"
    endif
endfunction

function! s:AckMotion(type) abort
    let reg_save = @@
    call s:CopyMotionForType(a:type)
    execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"
    let @@ = reg_save
endfunction
" }}}

"let g:multi_cursor_use_default_mapping=0

set number  "activate line number
set list    "show invisible characters
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set showbreak=↪
set shiftwidth=4
set tabstop=4
set splitbelow
set splitright
"set textwidth=80
"let &colorcolumn="80,".join(range(120,999),",")
let &colorcolumn=80

set spell spelllang=en_us
"set spell
set complete+=kspell


" easytags setting
" write to the first existing tags file seen by Vim
"set tags=./tags;
"let g:easytags_dynamic_files = 1
let g:easytags_ignored_filetypes = '^vim$'
"let g:easytags_ignored_filetypes = '^tex$'
let g:easytags_async = 1
" ensure it checks the project specific tags file
"let g:easytags_dynamic_files = 1
" configure easytags to run ctags after saving the buffer
"let g:easytags_events = ['BufWritePost']
let g:easytags_auto_update = 0
let g:easytags_by_filetype = '/Users/zuxfoucault/dotfiles/vimtags'
" nnoremap ¨ :UpdateTags -R . " see gui_macvim

"set tags+=tags
set tags=./.tags;,~/dotfiles/vimtags/latex

" Tagbar setting
let g:tagbar_compact = 1
let g:tagbar_type_tex = {
    \ 'ctagstype' : 'tex2',
    \ 'kinds'     : [
        \ 'S:Sections',
        \ 't:Topics',
        \ 'g:Graphics:0:0',
        \ 'l:Labels:0:0',
        \ 'r:Refs:0:0',
        \ 'p:Pagerefs:0:0',
        \ 'T:Timestamps:0:0'
    \ ],
    \ 'sort'    : 0,
\ }
"    \ 'deffile' : expand('<sfile>:p:h:h') . '/ctags/latex.cnf'
" avoid default Tex: c  chapters s  sections u  subsections b  subsubsections p  parts P  paragraphs G  subparagraphs l  labels

" Fugitive setting
"open the parent tree
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

"Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" {{{ CtrlP: default command to invoke CtrlP
let g:ctrlp_cmd = 'CtrlPMRU'
"let g:ctrlp_cmd = 'CtrlPMixed'

"let g:ctrlp_dont_split = 'NERD_tree_2'
"let g:ctrlp_jump_to_buffer = 0
"let g:ctrlp_working_path_mode = 0
"let g:ctrlp_match_window_reversed = 1
"let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 20
"let g:ctrlp_extensions = ['tag']
"
"let g:ctrlp_map = '<leader>,'
"nnoremap <leader>. :CtrlPTag<cr>
"nnoremap <leader>E :CtrlP ../
"
"let g:ctrlp_prompt_mappings = {
"\ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<s-tab>'],
"\ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<tab>'],
"\ 'PrtHistory(-1)':       ['<c-n>'],
"\ 'PrtHistory(1)':        ['<c-p>'],
"\ 'ToggleFocus()':        ['<c-tab>'],
"\ }
"
"let ctrlp_filter_greps = "".
"    \ "egrep -iv '\\.(" .
"    \ "jar|class|swp|swo|log|so|o|pyc|jpe?g|png|gif|mo|po" .
"    \ ")$' | " .
"    \ "egrep -v '^(\\./)?(" .
"    \ "deploy/|lib/|classes/|libs/|deploy/vendor/|.git/|.hg/|.svn/|.*migrations/|docs/build/" .
"    \ ")'"
"
"let my_ctrlp_user_command = "" .
"    \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*' | " .
"    \ ctrlp_filter_greps
"
"let my_ctrlp_git_command = "" .
"    \ "cd %s && git ls-files --exclude-standard -co | " .
"    \ ctrlp_filter_greps
"
"let my_ctrlp_ffind_command = "ffind --semi-restricted --dir %s --type e -B -f"
"
"let g:ctrlp_user_command = ['.git/', my_ctrlp_ffind_command, my_ctrlp_ffind_command]
"
" }}}


" fzf
set rtp+=/usr/local/opt/fzf
let g:fzf_command_prefix = 'FF'
let g:fzf_launcher = '/Users/zuxfoucault/dotfiles/fzf_MacVim.sh %s'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

" Override Colors command. You can safely do this in your .vimrc as fzf.vim
" will not override existing commands.
command! -bang Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)


" Customize fzf colors to match your color scheme
"let g:fzf_colors =
"\ { 'fg':      ['fg', 'Normal'],
"  \ 'bg':      ['bg', 'Normal'],
"  \ 'hl':      ['fg', 'Comment'],
"  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"  \ 'hl+':     ['fg', 'Statement'],
"  \ 'info':    ['fg', 'PreProc'],
"  \ 'border':  ['fg', 'Ignore'],
"  \ 'prompt':  ['fg', 'Conditional'],
"  \ 'pointer': ['fg', 'Exception'],
"  \ 'marker':  ['fg', 'Keyword'],
"  \ 'spinner': ['fg', 'Label'],
"  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Narrow ag results within vim
function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

" orig: ag --nogroup --column --color "%s"
command! -nargs=* Ag call fzf#run({
\ 'source':  printf('ag --smart-case --nogroup --column --color "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'
\ })


" fuzzy search files in parent directory of current file
function! s:fzf_neighbouring_files()
  let current_file =expand("%")
  let cwd = fnamemodify(current_file, ':p:h')
  let command = 'ag -g "" -f ' . cwd . ' --depth 0'

  call fzf#run({
        \ 'source': command,
        \ 'sink':   'e',
        \ 'options': '-m -x +s',
        \ 'window':  'enew' })
endfunction

command! FFNeigh call s:fzf_neighbouring_files()


" fzf-preview
if has('gui_macvim')
let g:fzf_preview_command = 'ccat -G Decimal="lightgrey" -G Keyword="lightgrey" -G Plaintext="lightgrey" --color=always {}'
endif

"numbers setting
let g:numbers_exclude = ['tagbar', 'gundo', 'nerdtree']


" indentLine
let g:indentLine_color_term = 24
let g:indentLine_color_gui = '#005f87'

" Trailing whitespace
" Only shown when not in insert mode.
augroup trailing " don't know why cause some trouble => it's encoding error
	au!
	au InsertEnter * :set listchars-=trail:»
	au InsertLeave * :set listchars+=trail:»
	"au InsertEnter * :set listchars-=trail:⌴
	"au InsertLeave * :set listchars+=trail:⌴
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


" vim-lexical setting
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile,tex call lexical#init()
  "autocmd FileType text call lexical#init({ 'spell': 0 })
  autocmd FileType text call lexical#init()
  autocmd FileType tex call lexical#init()
augroup END

let g:lexical#spell = 1
let g:lexical#dictionary = ['/usr/share/dict/words', '/usr/share/dict/web2a', '~/.vim/spell/en.utf-8.add', '~/.vim/thesaurus/mthesaur.txt',]
let g:lexical#spell_key = '<leader>s' " Spell-check
let g:lexical#dictionary_key = '<leader>k' " Dictionary completion
"let g:lexical#thesaurus = ['~/.vim/thesaurus/mthesaur.txt',] " define paths to thesauruses
"let g:lexical#thesaurus_key = '<leader>[' " Thesaurus lookup


" thesaurus_query
let g:tq_language=['en']
let g:tq_openoffice_en_file="/Users/zuxfoucault/.vim/thesaurus/MyThes-1.0/th_en_US_new"
let g:tq_enabled_backends = ["thesaurus_com",
							\"datamuse_com",
							\"openoffice_en",
							\"mthesaur_txt"]
"nnoremap <Leader>cs :ThesaurusQueryReplaceCurrentWord<CR>
"vnoremap <Leader>cs y:ThesaurusQueryReplace <C-r>"<CR>
nnoremap <Leader>] :ThesaurusQueryReplaceCurrentWord<CR>
vnoremap <Leader>] y:ThesaurusQueryReplace <C-r>"<CR>


"" Limelight integrated with Goyo
"autocmd User GoyoEnter Limelight
"autocmd User GoyoLeave Limelight!


" vim-textobj-quote
augroup textobj_quote
 autocmd!
  autocmd FileType markdown call textobj#quote#init()
  autocmd FileType textile call textobj#quote#init()
  autocmd FileType text call textobj#quote#init({'educate': 0})
  autocmd FileType tex call textobj#quote#init()
augroup END


" vim-textobj-sentence
augroup textobj_sentence
  autocmd!
  autocmd FileType markdown call textobj#sentence#init()
  autocmd FileType textile call textobj#sentence#init()
  autocmd FileType tex call textobj#sentence#init()
augroup END


" vim-wordy ring
let g:wordy#ring = [
  \ 'weak',
  \ ['being', 'passive-voice', ],
  \ 'business-jargon',
  \ 'weasel',
  \ 'puffery',
  \ ['problematic', 'redundant', ],
  \ ['colloquial', 'idiomatic', 'similies', ],
  \ 'art-jargon',
  \ ['contractions', 'opinion', 'vague-time', 'said-synonyms', ],
  \ ]

" NERDTree split explore
let g:NERDTreeHijackNetrw=1

" vim-wordy
nnoremap <silent> K :NextWordy<cr>

" map in operator-pending mode
"onoremap w iw

"Open new split panes to right and bottom, which feels more natural than Vim’s default
"set splitbelow "has been set above
"set splitright
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
"noremap <C-H> :tabp<CR>
"noremap <C-L> :tabn<CR>

" yankstack: key binding affected by yankstack;
call yankstack#setup()
nnoremap p gp
nnoremap P gP
nnoremap gp p
nnoremap gP P

" Yank text to the OS X clipboard
 noremap <leader>y "*y
 noremap <leader>yy "*Y

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
"remap tab navigation key
nnoremap $ gT
nnoremap ^ gt

"Simple calculations with Vim's expression register
"nnoremap Q 0yt=A<C-r>=<C-r>"<CR><Esc>

"move to eol and save text
"nnoremap ∂  :put =expand('%:p')<CR> " put the file path, see gui_macvim
"nnoremap ô  :r !date "put the date-time info.
"nnoremap ó :call Aasa()<CR> "init auto save


" Open a Quickfix window for the last search.
nnoremap <silent><Leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Switching to the previously edited buffer "or :b#
"noremap <F10> <C-^>

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
	"nnoremap Ω  mzzMzvzz`z:Pulse<cr>
	nnoremap Ω  mzzMzvzz`z:call PulseCursorLine()<cr>
	"nnoremap ¨ :UpdateTags! -R .<CR>
	nnoremap ¨ :UpdateTags! %<CR>
	"update ctags
	nnoremap ∂ :put =expand('%:p')<CR>
	"put the file path
	"nnoremap ô :r !date<CR>
	"nnoremap ô :r !date "+\%\%>>\%Y\%m\%d \%H:\%M:\%S \%A \%Z"<CR>
	"put the date-time info.
	nnoremap ó :call Aasa()<CR>
	"init auto save
else
	"nnoremap <M-z> mzzMzvzz1<c-e>`z:Pulse<cr>
	"nnoremap <M-z> mzzMzvzz`z:Pulse<cr>
	nnoremap <M-z> mzzMzvzz10<c-e>`z:call PulseCursorLine()<cr>
	"nnoremap <M-u> :UpdateTags! -R .<CR>
	nnoremap <M-u> :UpdateTags! %<CR>
	"update ctags
	nnoremap <M-d> :put =expand('%:p')<CR>
	"put the file path
	"nnoremap <M-t> :r !date<CR>
	"nnoremap <M-t> :r !date "+\%\%>>\%Y\%m\%d \%H:\%M:\%S \%A \%Z"<CR>
	"put the date-time info.
	nnoremap <M-s> :call Aasa()<CR>
	"init auto save
endif

nnoremap <F10> :r !date "+\%\%>>\%Y\%m\%d \%H:\%M:\%S \%A \%Z"<CR>o


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

" {{{ Pulse the cursor line when repeating a search with "n" or "N"
if has('gui_running')
let g:PulseColorList = [ '#2a2a2a', '#333333', '#3a3a3a', '#444444', '#4a4a4a' ]
let g:PulseColorattr = 'guibg'
else
let g:PulseColorList = [ 'DarkGrey', 'DarkGrey', 'DarkGrey' ]
let g:PulseColorattr = 'ctermbg'
endif
function! PulseCursorLine()
for pulse in g:PulseColorList
execute 'hi CursorLine ' . g:PulseColorattr . '=' . pulse
redraw
sleep 6m
endfor
for pulse in reverse(copy(g:PulseColorList))
execute 'hi CursorLine ' . g:PulseColorattr . '=' . pulse
redraw
sleep 6m
endfor
execute 'hi CursorLine ' . g:PulseColorattr . '=NONE'
endfunction
" }}}

"}}}

"function! MyFoldText() " {{{
"    let line = getline(v:foldstart)
"
"    let nucolwidth = &fdc + &number * &numberwidth
"    let windowwidth = winwidth(0) - nucolwidth - 3
"    let foldedlinecount = v:foldend - v:foldstart
"
"    " expand tabs into spaces
"    let onetab = strpart('          ', 0, &tabstop)
"    let line = substitute(line, '\t', onetab, 'g')
"
"    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
"    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
"    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
"endfunction " }}}
"set foldtext=MyFoldText()

" }}}


let g:vim_search_pulse_mode = 'pattern'
let g:vim_search_pulse_disable_auto_mappings = 1
let g:vim_search_pulse_duration = 50
" default: 400


" Toggle Gundo
nnoremap <F2> :GundoToggle<CR>
let g:gundo_prefer_python3 = 1

"NERD Tree\
nnoremap  <F6> :NERDTreeToggle<cr>
"NERD Tree split explore
"nnoremap  <F6> :e.<cr>

" Tagbar
nnoremap <F8> :TagbarToggle<CR>

"Syntastic
noremap <F1> :SyntasticReset<CR>
inoremap <F1> <ESC>:SyntasticReset<CR>
" Temporarily disable checker
"let g:syntastic_check_on_wq = 0
" For :lnext and :lprev to work
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_full_redraws
"let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

" invoke EasyMotion <Leader><Leader>
"map <F4> <Leader><Leader>
"imap <F4> <ESC><Leader><Leader>
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
"map n <Plug>(easymotion-next)
"map N <Plug>(easymotion-prev)

" vim-wheel
let g:wheel#map#up   = '<D-k>'
let g:wheel#map#down = '<D-j>'

" Vim-R-plugin
let r_syntax_folding = 1

" invoke suggest words
inoremap <F3> <ESC>z=
"inoremap <F3> <C-x><C-k>
nnoremap <F3> i<C-x><C-s>
"noremap <F3> z=
"noremap <F3> <LEADER>s


" FZF mapping
nnoremap <C-b>b :FFBTags<CR>
nnoremap <C-b><Space> :FFTags<CR>


" python
autocmd BufRead *.py set expandtab "shiftwidth=4 tabstop=4

" avoid key map conflict between py-mode and buffergator
let g:pymode_breakpoint_bind = '<leader><leader>b'
let g:pymode_rope = 0
let g:pymode_python = 'python3'
"let g:pymode_rope_completion = 0
"let g:pymode_lint = 0
"let g:pymode_virtualenv = 0
"let g:pymode_python = 'python' #set Python version, however virtualenv supported
"let g:pymode_rope_completion_bind = '<C-Space>m'

" YCM
"let g:ycm_path_to_python_interpreter = '/usr/bin/python'
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python3'
"let g:ycm_path_to_python_interpreter = '/Volumes/SSD/Space/miniconda3/bin/python'
"let g:ycm_path_to_python_interpreter = '/Volumes/SSD/Space/miniconda3/bin/python'
"show the completion menu even when typing inside comments.
let g:ycm_complete_in_comments = 1
"collect identifiers from strings and comments
let g:ycm_collect_identifiers_from_comments_and_strings = 1
"collect identifiers from tags files.
let g:ycm_collect_identifiers_from_tags_files = 1
"completer will seed its identifier with the keywords of current programming language 
let g:ycm_seed_identifiers_with_syntax = 1
"
"au BufNew,BufEnter,BufRead *.c,*.cpp,*.hpp let g:ycm_global_extra_conf='/Users/zuxfoucault/.vim/vim-addons/YouCompleteMe/.ycm_extra_conf.py'

"nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>
"" upported in filetypes: 'c, cpp, objc, objcpp, python, cs'
"nnoremap <leader>je :YcmCompleter GoToDefinition<CR>

" yankstack: avoid <mete- > in vim terminal
if !has('gui_macvim')
nmap π <Plug>yankstack_substitute_older_paste
nmap ∏ <Plug>yankstack_substitute_newer_paste
"nmap <leader>p <Plug>yankstack_substitute_older_paste
"nmap <leader>P <Plug>yankstack_substitute_newer_paste
endif


" vim-gitgutter recommend setting
set updatetime=100


if has('gui_macvim')
highlight Comment cterm=italic
endif

"vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"Tabular
"let mapleader=','
if exists(":Tabularize")
	nmap <Leader>a= :Tabularize /=<CR>
	vmap <Leader>a= :Tabularize /=<CR>
	nmap <Leader>a: :Tabularize /:\zs<CR>
	vmap <Leader>a: :Tabularize /:\zs<CR>
endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction


"set timeout timeoutlen=3000 ttimeoutlen=100
set ttimeoutlen=100

" GUI related
if has('gui_macvim')
"set guifont==Monaco:h26
"set guifont=Menlo\ Regular:h24
"set guifont=Consolas:h28
set guifont=Anonymous\ Pro:h30

"MacVim: switch OSX windows with swipes
"nnoremap <silent> <SwipeLeft> :macaction _cycleWindowsBackwards:<CR>
"nnoremap <silent> <SwipeRight> :macaction _cycleWindows:<CR>
set guicursor+=a:blinkon0
"set transparency=15
set guioptions-=r " Hide scrollbars
set macmeta
set linespace=5
endif

setlocal foldmethod=marker


" Function of open non-text file from vim; map with `gl`
" Note: `gf` will open text in new window
" Note: `gx` will open web hyperlink in browser
function OpenNonTextFile()
	let line = getline('.')
	"let line = substitute(line, '\a', "*", "g")
	"execute "silent !open " . line
	execute "!open " . line
endfunction
nnoremap gl :call OpenNonTextFile()<CR>

" auto-save while text changed {{{
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
" }}}

"  StripTrailingWhitespace {{{
function! StripTrailingWhitespace()
  normal mZ
  let l:chars = col("$")
  %s/\s\+$//e
  if (line("'Z") != line(".")) || (l:chars != col("$"))
    echo "Trailing whitespace stripped\n"
  endif
  normal `Z
  normal mZ
endfunction
" }}}

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
"nnoremap n nzzzv
"nnoremap n nzzzv
"after implement PulseCursorLine
"nnoremap n nzzzv:call PulseCursorLine()<cr>
"nnoremap N Nzzzv:call PulseCursorLine()<cr>
"after install vim-search-pulse
nmap n nzzzv<Plug>Pulse
nmap N Nzzzv<Plug>Pulse
nmap * *zzzv<Plug>Pulse
nmap # #zzzv<Plug>Pulse
" Pulses cursor line on first match
" when doing search with / or ?
"cmap <enter> <Plug>PulseFirst "not good, next line will cancel it
cmap <enter> <enter>

"Save A File In Vim / Vi Without Root Permission
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Omni completion 
set omnifunc=syntaxcomplete#Complete


" vim-signature; taking out `z` for pulse usage
let g:SignatureIncludeMarks = 'abcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXYZ'

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

nnoremap <silent> <leader>0 :call clearmatches()<cr>
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

" UltiSnips
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

"Snippet Search Path
let g:UltiSnipsSnippetDirectories=["UltiSnips"]


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

" Customized nerdtree preview function {{{
let g:nerd_preview_enabled = 0
let g:preview_last_buffer  = 0

function! NerdTreePreview()
  " Only on nerdtree window
  if (&ft ==# 'nerdtree')
    " Get filename
    let l:filename = substitute(getline("."), "^\\s\\+\\|\\s\\+$","","g")

    " Preview if it is not a folder
    let l:lastchar = strpart(l:filename, strlen(l:filename) - 1, 1)
    if (l:lastchar != "/" && strpart(l:filename, 0 ,2) != "..")

      let l:store_buffer_to_close = 1
      if (bufnr(l:filename) > 0)
        " Don't close if the buffer is already open
        let l:store_buffer_to_close = 0
      endif

      " Do preview
      execute "normal go"

      " Close previews buffer
      if (g:preview_last_buffer > 0)
        execute "bwipeout " . g:preview_last_buffer
        let g:preview_last_buffer = 0
      endif

      " Set last buffer to close it later
      if (l:store_buffer_to_close)
        let g:preview_last_buffer = bufnr(l:filename)
      endif
    endif
  elseif (g:preview_last_buffer > 0)
    " Close last previewed buffer
    let g:preview_last_buffer = 0
  endif
endfunction

function! NerdPreviewToggle()
  if (g:nerd_preview_enabled)
    let g:nerd_preview_enabled = 0
    augroup nerdpreview
      autocmd!
      augroup END
  else
    let g:nerd_preview_enabled = 1
    augroup nerdpreview
      autocmd!
      autocmd CursorMoved * nested call NerdTreePreview()
    augroup END
  endif
endfunction
"}}}


" Automated Working Directories Jumping with Fuzzy Search
" Ref: http://inlehmansterms.net/2014/09/04/sane-vim-working-directories/
" follow symlinked file
function! FollowSymlink()
  let current_file = expand('%:p')
  " check if file type is a symlink
  if getftype(current_file) == 'link'
    " if it is a symlink resolve to the actual file path
    "   and open the actual file
    let actual_file = resolve(current_file)
    silent! execute 'file ' . actual_file
  end
endfunction

" set working directory to git project root
" or directory of current file if not git project
function! SetProjectRoot()
  " default to the current file's directory
  lcd %:p:h
  let git_dir = system("git rev-parse --show-toplevel")
  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project, change local directory to git project root
  if empty(is_not_git_dir)
    lcd `=git_dir`
  endif
endfunction

" follow symlink and set working directory
autocmd BufRead *
  \ call SetProjectRoot()
"  \ call FollowSymlink() |


" Setup markdown preview
function! s:setupMarkup()
  "nnoremap <leader>l :silent !open -a MacDown.app '%:p'<cr>
  nnoremap <D-r> :silent !open -a MacDown.app '%:p'<cr>
endfunction
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()



"let g:indent_guides_auto_colors = 0
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
" 随 vim 自启动
let g:indent_guides_enable_on_vim_startup=1
" 从第二层开始可视化显示缩进
let g:indent_guides_start_level=2
" 色块宽度
let g:indent_guides_guide_size=1
" 快捷键 i 开/关缩进可视化
:nmap <silent> <Leader>i <Plug>IndentGuidesToggle

"" automatic change vim root directory for ctrlp
"autocmd BufEnter * silent! lcd %:p:h

" Split Words Into Lines
" :26call SplitToLines()
" 1,10call SplitToLines()
" '<,'>call SplitToLines() in Visual mode
function SplitToLines() range
  for lnum in range(a:lastline, a:firstline, -1)
    let words = split(getline(lnum))
    execute lnum . "delete"
    call append(lnum-1, words)
  endfor
endfunction

" Add template automatically
"au BufNewFile N2016*0000.tex 0r /Volumes/SSD/googleDrive/papers/texNote/journal/template.tex
"au BufNewFile *.tex 0r /Volumes/SSD/googleDrive/papers/texNote/journal/template.tex
au BufNewFile *.tex
	\ if expand('%:p') =~ '/Volumes/SSD/googleDrive/papers/texNote/journal/N20.*0000' |
	\ 0r /Volumes/SSD/googleDrive/papers/texNote/journal/templateJournal.tex |
	\ execute 'r !date "+\%\%>>\%Y\%m\%d \%H:\%M:\%S \%A \%Z"' |
	\ execute "normal! j" | start |
	\ else |
	\ 0r /Volumes/SSD/googleDrive/papers/texNote/journal/template.tex |
	\ endif
