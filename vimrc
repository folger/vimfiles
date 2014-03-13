set go-=m "remove the menu bar
set go-=T "remove the toolbar

set backspace=2 "make backspace work like most other apps
set number

set smartindent
set tabstop=4
set shiftwidth=4

set laststatus=2

set statusline=%F\ %m\ %y%=%l,%c\%P
set hlsearch
set nowrap

set ignorecase
set smartcase

" adjust configuration for such hostile environment as Windows {{{
if has("win32") || has("win16")
  let g:tagbar_ctags_bin = 'C:\Box\Windows\CTags\ctags.exe'
else
  let g:tagbar_ctags_bin = '/opt/local/bin/ctags'
endif
" }}}



"CtrlP settings
let g:ctrlp_by_filename = 1


filetype plugin on
filetype indent plugin on

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
nnoremap <CR> :noh<CR><CR>


