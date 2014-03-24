set nocompatible   " Disable vi-compatibility

set history=200

set go-=m "remove the menu bar
set go-=T "remove the toolbar

set backspace=2 "make backspace work like most other apps
set number

set smartindent
set tabstop=4
set shiftwidth=4

set laststatus=2  " Always show the statusline

set statusline=%F\ %m\ %y%=%l,%c\%P
set hlsearch
set nowrap

set ignorecase
set smartcase


set encoding=utf-8
let &termencoding=&encoding
set fileencodings=utf-8,gbk
set guifont=Courier_New:h10
set guifontwide=NSimSun:h10


"CtrlP settings
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:30'


"clang_complet
"let g:clang_auto_select = 2 
"let g:clang_complete_copen=1
"let g:clang_periodic_quickfix=1
"let g:clang_snippets=1
let g:clang_use_library=1
let g:clang_close_preview=1
let g:clang_user_options='-stdlib=libc++ -std=c++11 -IIncludePath'


" adjust configuration for such hostile environment as Windows {{{
if has("win32") || has("win16")
  let g:tagbar_ctags_bin = 'C:\Box\Windows\CTags\ctags.exe'
  let g:clang_library_path="D:/clang_lib/"
else
  let g:tagbar_ctags_bin = '/opt/local/bin/ctags'
  let g:clang_library_path="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/"
endif
" }}}


filetype plugin on
filetype indent plugin on


"Python file specific settings
autocmd Filetype python setlocal expandtab


execute pathogen#infect()




"color-solarized settings
syntax enable
set background=dark
let g:solarized_italic = 0
colorscheme solarized





syntax on

map , <C-W>

map <F2> :NERDTreeToggle<CR>
map <F8> :TagbarToggle<CR>

noremap <Esc> :noh<bar>pclose<CR><Esc>
noremap <script> <silent> <unique> <Leader>bb :BufExplorer<CR>

map <C-K><C-O> :Gist -l<CR>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

