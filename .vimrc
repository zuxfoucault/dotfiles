
        " put this line first in ~/.vimrc
        set nocompatible | filetype indent plugin on | syntax on

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
          let plugin_root_dir = expand('$HOME/.vim/vim-addons')
          if !EnsureVamIsOnDisk(plugin_root_dir)
            echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
            return
          endif
          let &rtp.=(empty(&rtp)?'':',').plugin_root_dir.'/vim-addon-manager'
          
	  " Tell VAM which plugins to fetch & load:
          call vam#ActivateAddons(['Powerline', 'AutomaticLaTeXPlugin'], {'auto_install' : 0})
          " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

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
        " experimental [E2]: run after gui has been started (gvim) [3]
        " option1:  au VimEnter * call SetupVAM()
        " option2:  au GUIEnter * call SetupVAM()
        " See BUGS sections below [*]
        " Vim 7.0 users see BUGS section [3]



" System vimrc file for MacVim
"
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

"29 syntax enable
 let g:solarized_termtrans = 1
 colorscheme solarized
"togglebg#map("<F5>") 

" Yank text to the OS X clipboard
noremap <leader>y "*y
noremap <leader>yy "*Y

" Preserve indentation while pasting text from the OS X clipboard
noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

" Pathogen setting
" 29 call pathogen#infect('bundle')
" 29 filetype plugin indent on

" vim-latex setting
" 29 set grepprg=grep\ -nH\ $*

" ATP-setting
 let g:atp_tab_map = 1

 set number  "activate line number
 " set list    "show invisible characters
