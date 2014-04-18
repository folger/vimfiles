set nocompatible   "" Disable vi-compatibility

"set virtualedit=all ""let the cursor stray beyond the defined text

""Vim kept flashing when press <ESC> when this is on under Windows
"set vb t_vb= ""get rid of the annoying beeps when command doesn't work

set backupdir=~/vimbackup,.
set dir=~/vimbackup,.

"augroup vimrc
  "au BufReadPre * setlocal foldmethod=indent
  "au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
"augroup END

set hidden

set history=200

set go-=m ""remove the menu bar
set go-=T ""remove the toolbar

set backspace=2 ""make backspace work like most other apps
set number

set incsearch
set tabstop=4
set shiftwidth=4

set laststatus=2  "" Always show the statusline

set hlsearch
set nowrap

set ignorecase
set smartcase


set encoding=utf-8
let &termencoding=&encoding
set fileencodings=ucs-bom,utf-8,gbk
set ambiwidth=double

""CtrlP settings
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:30'


""clang_complet
"let g:clang_auto_select = 2 
"let g:clang_complete_copen=1
"let g:clang_periodic_quickfix=1
"let g:clang_snippets=1
let g:clang_use_library=1
let g:clang_close_preview=1
let g:clang_user_options='-stdlib=libc++ -std=c++11 -IIncludePath'


""syntastic settings
let g:syntastic_ignore_files = ['\m\c\.py$', '\m\c\.pyw$']

""pymode settings
let g:pymode_python = 'python'
let g:pymode_rope = 0
let g:pymode_lint_ignore = "E501,E265,C901"

""tagbar settings
let g:tagbar_autofocus = 1

"" adjust configuration for such hostile environment as Windows {{{
if has("win32") || has("win16")
  set lines=50 columns=130
  let g:tagbar_ctags_bin = 'D:\clang_lib\ctags.exe'
  let g:clang_library_path="D:/clang_lib/"
  set tags=C:\Dev\Source\tags
  set guifont=Courier_New:h10
  set guifontwide=NSimSun:h10

  nmap <F11> :!start explorer /e,%:p:h<CR>
  nmap <S-F11> :!start explorer /select,%:p<CR>
else
  let g:tagbar_ctags_bin = '/opt/local/bin/ctags'
  let g:clang_library_path="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/"
  set guifont=Menlo:h11

  nmap <Leader>f :!open %:p:h<CR>
endif

  imap <F11> <Esc><F11>
"" }}}


filetype indent plugin on
"" according to
"" http://stackoverflow.com/questions/18415492/autoindent-is-subset-of-smartindent-in-vim,
"" smartindent is deprecated and should not be used
set autoindent
"set smartindent


""Python file specific settings
autocmd Filetype python setlocal expandtab
autocmd Filetype vim setlocal tabstop=2 shiftwidth=2 expandtab


execute pathogen#infect()




""colorscheme settings
syntax enable
set background=dark
"let g:solarized_italic = 0
"colorscheme solarized
colorscheme desert



autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview 


set pastetoggle=<F3>


map , <C-W>

map <F2> :NERDTreeToggle<CR>
map <F8> :TagbarToggle<CR>

noremap <Esc> :noh<bar>pclose<CR><Esc>
noremap <script> <silent> <unique> <Leader>bb :BufExplorer<CR>

nnoremap <C-K><C-o> :Gist -l<CR>
nnoremap <C-K><C-m> :call AddModificationLog()<CR>
nnoremap <C-k><C-l> :Gstatus<CR>
nnoremap <C-k><C-i> :MRU<CR>
nnoremap <C-k><C-d> :Gdiff<CR>
nnoremap <C-k><C-p> :CtrlP 
nnoremap <C-k><C-z> :call AddCodeMakingBegin()<CR>
nnoremap <C-k><C-x> :call AddCodeMakingEnd()<CR>
nnoremap <C-k><C-n> :call CompileCurrentFile()<CR>
nnoremap <C-k><C-b> :call BuildProject()<CR>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-k> <Left>
cnoremap <C-l> <Right>

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

nnoremap <silent> [n :cprevious<CR>
nnoremap <silent> ]n :cnext<CR>

nnoremap <space> za


cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

""
""
""
"" Custom functions
""
""
""
""add code marking to modification log, OrgLab stuff
function! AddModificationLog()
	g/ \*-\+\*\//normal O*	Folger =strftime("%m/%d/%Y") =g:jira=g:codem
endfun

function! AddCodeMakingBegin()
  let l:tt = &formatoptions
  exe "set formatoptions-=cro"
  normal O///------ Folger =strftime("%m/%d/%Y") =g:jira=g:codem
  let &formatoptions = l:tt
endfun

function! AddCodeMakingEnd()
  let l:tt = &formatoptions
  exe "set formatoptions-=cro"
  normal o///------ End =g:codem
  let &formatoptions = l:tt
endfun

function! BuildProject()
  exe "!start python H:/CheckCode/Python/BuildProj/BuildCmd.py " . g:proj
endfun

function! CompileCurrentFile()
  exe "!start python H:/CheckCode/Python/BuildProj/BuildCmd.py " . g:proj . " %:t"
endfun

""substitude git diff relative path
function! SubGitDiffPath()
	%s/^diff --git a\/\(\S*\) b\/\(.*\)/diff --git a\/Source\/Moudle\/scintilla\/\1 b\/\Source\/Module\/scintilla\/\2/g
	%s/^\([-+]\{3} [ab]\)\/\(.*\)/\1\/Source\/Module\/scintilla\/\2/g
endfunc

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
