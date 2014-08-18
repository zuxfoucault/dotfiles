" Seth R. Johnson
" https://github.com/sethrj/SRJ-Vim-Resources

"Only indent a little, and use spaces for it
"setlocal sw=2 ts=2
"setlocal expandtab
"Break lines at 80 chars
"setlocal textwidth=80

"Ignore log and aux files
"setlocal wildignore=*.log,*.aux,*.bbl,*.out

" turn spell checking on
setlocal spell

"if has('gui_macvim')
" let the option key act as the "meta" key for vim-ltex completions
"	setlocal macmeta

" let Latex-Suite will create sub-menus
	"let g:Tex_Menus = 1
"endif

" Before you start with Latex-Suite's completion function...
"setlocal grepprg=grep\ -nH\ $*

set iskeyword+=:
"setlocal iskeyword+=:,- "for pattern like “fig:design-diagram,”

" *********** FOR USE WITH SKIM ETC.
" http://mactex-wiki.tug.org/wiki/index.php/SyncTeX
"--remote-silent +":%line;foldo!" "%file"
let g:Tex_DefaultTargetFormat = 'pdf'
 
"let g:Tex_TreatMacViewerAsUNIX = '1'

let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
let g:Tex_CompileRule_ps = 'dvips -Pwww -o $*.ps $*.dvi'
let g:Tex_CompileRule_pspdf = 'ps2pdf $*.ps'
let g:Tex_CompileRule_dvipdf = 'dvipdfm $*.dvi'
"let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 --interaction=nonstopmode $*'
"let g:Tex_CompileRule_pdf = 'latexmk -synctex=1 --interaction=nonstopmode $*'
"let g:Tex_CompileRule_pdf = 'latexmk  -pdf $*'
let g:Tex_CompileRule_pdf = 'latexmk $*'
 
let g:Tex_ViewRule_dvi = 'texniscope'
"let g:Tex_ViewRule_ps = 'Preview'
let g:Tex_ViewRule_ps = 'Skim'
let g:Tex_ViewRule_pdf = 'Skim'
"let g:Tex_ViewRuleComplete_pdf = 'start open -a Skim.app "$*.pdf" &' "not
"worked

let g:Tex_FormatDependency_ps  = 'dvi,ps'
let g:Tex_FormatDependency_pspdf = 'dvi,ps,pspdf'
let g:Tex_FormatDependency_dvipdf = 'dvi,dvipdf'
"let g:Tex_MultipleCompileFormats = 'dvi,pdf'
" multiple compile seems kind of buggy
let g:Tex_MultipleCompileFormats = ''

" don't move the main window around after compiling
let g:Tex_GotoError = 0

" Ignore missing references too
let g:Tex_IgnoredWarnings =
	\'Underfull'."\n".
	\'Overfull'."\n".
	\'specifier changed to'."\n".
	\'You have requested'."\n".
	\'Missing number, treated as zero.'."\n".
	\'There were undefined references'."\n".
	\'Citation %.%# undefined'."\n".
	\'Reference %.%# undefined'

let g:Tex_IgnoreLevel = 8

" ignore makefiles
let g:Tex_UseMakefile = 0

"let g:Tex_Debug = 1
"let g:Tex_DebugLog = '~/vimlatex.log'

" ************

" ************
" Look for main file by looking in the first 20 lines, same as TeXShop, for:
" % !TEX root = [filename].tex
" Author: Seth R. Johnson
let g:Tex_MainFileExpression = 'SRJMainFile(modifier)'

function! SRJMainFile(fmod)
	let s:Tex_Match = '\v^\s*\%\s+!TEX\s+root\s+\=\s+\zs(.*\.tex)\ze\s*$'
    let s:lnum = 1
    while s:lnum < 20
		let s:basefile = matchstr( getline(s:lnum), s:Tex_Match)
		if !empty(s:basefile)
			break
		endif
		let s:lnum += 1
    endwhile

	if !empty(s:basefile)
		let s:origdir = fnameescape(getcwd())
		let s:newdir = fnameescape(expand('%:p:h'))
		exec 'cd'.s:newdir
		let s:basefile = fnamemodify(s:basefile, a:fmod) 
		exec 'cd'.s:origdir
	else
		let s:basefile = expand('%'.a:fmod)
	endif

	return s:basefile
endfunction

" Write, open for viewing, compile, go to the end of the quickfix, hide the
" preview, switch back to main window
"map <D-r> :w<cr><leader>lv<leader>ll<C-w>p:q<cr>
"map <D-r> :w<cr><leader>lv<leader>ll
"map <D-r> <leader>ll<leader>ls
map <D-r> <leader>ll<leader>ls<C-w>_
imap <D-r> <ESC><D-r>
"map <D-e> <C-w>j;q<cr>
map <D-e> ;only<CR>
" because remap ; :, explain above setting 
" Inverse search
"nmap <D-S-LeftMouse> <leader>ls

" ************


"let g:Tex_ViewRule_pdf = '/Applications/Preview.app/Contents/MacOS/Preview'
"let g:Tex_CompileRule_pdf = '/usr/texbin/pdflatex --shell-escape $*'

"let g:Tex_Menus=0
let g:Tex_HotKeyMappings='align*,align,bmatrix'

let g:Tex_PromptedCommands='parencite,textcite,phantomsection\label,hyperref,footnote,pageref'



"call IMAP('REQ', 'Eq.~\eqref{eq:<++>}<++>', 'tex')
"call IMAP('REEQ', 'Eqs.~\eqref{eqs:<++>}<++>', 'tex')
call IMAP('FIT', '\textit{<++>}<++>', 'tex')
call IMAP('SOU', '\sout{', 'tex')
call IMAP('ULI', '\uline{', 'tex')
"call IMAP('ULI', '\uline{<++>}<++>', 'tex')
"call IMAP('RFI', 'Fig.~\ref{fig:<++>}<++>', 'tex')
"call IMAP('RTA', 'Table~\ref{tab:<++>}<++>', 'tex')
"call IMAP('RSE', '\S\ref{sec:<++>}<++>', 'tex')
"call IMAP('RCH', 'Chapter~\ref{chap:<++>}<++>', 'tex')
call IMAP('PSSE', '\begin{spacing}{1}\section{<++>}\end{spacing}', 'tex')
"
"call IMAP('EFI', "\\begin{figure}[htb]\<cr>\\centering\<cr>\\includegraphics[width=3in]{<+file+>}\<cr>\\caption{<+caption text+>}\<cr>\\label{fig:<+label+>}\<cr>\\end{figure}<++>", "tex")
"call IMAP('ESU', '\subfloat[<++>]{% <++>% }% <++>', 'tex')
"call IMAP('ETA', "\\begin{table}[htb]\<cr>\\centering\<cr>\\begin{tabular}{<+dimensions+>}\<cr><++>\<cr>\\end{tabular}\<cr>\\caption{<+Caption text+>}\<cr>\\label{tab:<+label+>}\<cr>\\end{table}<++>", "tex")
"
"call IMAP('`R', '\Rightarrow', 'tex')
""call IMAP('`i', '\imagi', 'tex')
"call IMAP('`1', '\oder{<++>}{<++>}<++>', 'tex')
"call IMAP('`!', '\pder{<++>}{<++>}<++>', 'tex')
"call IMAP('`3', '\topbox{<++>}<++>', 'tex')

" avoid conflict with UltiSnips
imap <C-f> <Plug>IMAP_JumpForward

" avoid <F1> remapping issue
map <Nop> <Plug>Tex_Help
imap <Nop> <Plug>Tex_Help

""command-shift-1
"imap <D-!> align*<F5>
""command-2
"imap <D-2> equation<F5>
""command-shift-2
"imap <D-@> equation*<F5>
""command-3
"imap <D-3> \\ <cr>\intertext{<++>}<cr>  <++><Up><Up><C-j>
""command-4
""imap <D-4> itemize<F5>
"
""convert equation* into equation with label
"map <D-4> /equation\*<CR>wxNwxa\label{eq:}<left>

"disable folding by default
"let g:Tex_AutoFolding=0

" select Syntastic checkers
let g:syntastic_tex_checkers = ['chktex']

" " Run LaTeX through TexShop {{{
" " http://reference-man.blogspot.com/2009/01/vimtexshop-integration.html
" function! SRJ_runLatex()
"   if &ft != 'tex'
"     echo "calling srj_runLatex from a non-tex file"
"     return ''
"   end
" 
"   "write the file
"   :w
" 
"   let thePath = getcwd() . '/'. expand("%")
" 
"   let execString = 'osascript -e "tell app \"TeXShop\"" -e "set theDoc to open ((POSIX file \"'.thePath.'\") as alias)" -e "tell theDoc to latexinteractive" -e "end tell"'
"   exec 'silent! !'.execString
"   return ''
" endfunction
" no  <expr> <D-r> SRJ_runLatex()
" vn  <expr> <D-r> SRJ_runLatex()
" ino <expr> <D-r> SRJ_runLatex()

"no  <expr> <D-r> 
"vn  <expr> <D-r> 
"ino <expr> <D-r> 

" Disable matching parenthesis for TeX to reduce processor usage while typing
"NoMatchParen
"set sm " }}}


