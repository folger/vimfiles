set go-=m "remove the menu bar
set go-=T "remove the toolbar

set backspace=2 "make backspace work like most other apps
set number
set ts=4

set laststatus=2

set statusline=%F\ %m\ %y%=%l,%c\%P
set hlsearch
set nowrap

set ignorecase
set smartcase

let g:tagbar_ctags_bin = 'C:\Box\Windows\CTags\ctags.exe'

execute pathogen#infect()

syntax enable
set background=dark
let g:solarized_italic = 0
colorscheme solarized

syntax on
map <F2> :NERDTreeToggle<CR>
map <F8> :TagbarToggle<CR>



