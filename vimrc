"" Basic settings {{{
set nocompatible   "" Disable vi-compatibility
set modelines=0

"set virtualedit=all ""let the cursor stray beyond the defined text

""Vim kept flashing when press <ESC> when this is on under Windows
"set vb t_vb= ""get rid of the annoying beeps when command doesn't work

let mapleader=','

set backupdir=~/vimbackup,.
set dir=~/vimbackup,.

set hidden

set history=200

set scrolloff=3

set guioptions-=m ""remove the menu bar
set guioptions-=T ""remove the toolbar
"" remove scroll bars
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

"set relativenumber
set cursorline
"set cursorcolumn
set backspace=2 ""make backspace work like most other apps
"set number

set hlsearch
set incsearch
set showmatch
set tabstop=4
set shiftwidth=4
set shellslash

set wildmenu              ""command-line show menu when tab
"set gcr=a:blinkon0        ""cursor no blink

set laststatus=2  "" Always show the statusline
set statusline=
set statusline+=%6*[%n]                              "buffernr
set statusline+=%6*\ %<%F                            "Filename
set statusline+=%5*\ [%{fugitive#head(7)}]           "Git current branch
set statusline+=%2*\ %y                              "FileType
set statusline+=%3*\ %{&fenc!=''?&fenc:'none'}       "Encoding
set statusline+=%3*\ %{&bomb?\"BOM\":''}             "Encoding2
set statusline+=%4*\ %{&ff}                          "FileFormaqt
set statusline+=%5*\ %{BuildInfo()}                  "Build Info
set statusline+=%7*\ %=%{v:register}[%l,\ %c]/%L     "Active buffer, line, row, total rows, top/bot
set statusline+=%8*\ \ %m%r%P

set ignorecase
set smartcase

set encoding=utf-8
let &termencoding=&encoding
set fileencodings=ucs-bom,utf-8,sjis,gbk
set ambiwidth=double
set complete+=k

set undofile
set undodir=~/vimbackup
"" }}}

"" CtrlP settings {{{
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:30'
let g:ctrlp_working_path_mode = 'ra'
let g:backup_ctrlp_working_path_mode = g:ctrlp_working_path_mode
set wildignore+=*.o,*.obj,*.lib,*.dll,*.exe,
      \*.pdb,*.exp,*.ilk,*.tlog,*.pch,*.idb,*.cache,
      \*.emf,*.jpg,*.jpeg,*.png,*.bmp,*.chm,
      \*.otp,*.otw,*.otm,*.opj
"" }}}
"" Tagbar settings {{{
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
"" }}}
"" NERDTree settings {{{
"let g:NERDTreeHijackNetrw = 0
"" }}}
"" Adjust configuration for such hostile environment as Windows, and others {{{
if has("win32") || has("win16")
  set lines=35 columns=165
  let g:tagbar_ctags_bin = 'D:\clang_lib\ctags.exe'
  let g:clang_library_path="D:/clang_lib/"
  set guifont=Microsoft_YaHei_Mono:h13
  "set guifontwide=NSimSun:h11

  function! MakeWindowsPath(path)
    return substitute(expand(a:path), '/', '\', 'g')
  endfunction
  nnoremap <silent> <F11> :execute 'silent !start explorer /select,' . MakeWindowsPath('%:p')<CR>
  nnoremap <silent> <S-F11> :execute 'silent !start explorer /e,' . MakeWindowsPath('%:p:h')<CR>
  nnoremap <silent> <C-F11> :execute 'silent !start cmd.exe /K cd /D ' . MakeWindowsPath('%:p:h')<CR>

  function! SetupProj()
    "let l:proj = input('Project: ')
    "if len(l:proj) > 0
      "let g:proj = l:proj
    "endif
    "echomsg ' '
    let l:configs = ['Select a configuration:',
                \ '1 Win32 Debug',
                \ '2 x64 Debug',
                \ '3 Win32 Release',
                \ '4 x64 Release',
                \]
    let l:config = inputlist(l:configs)
    if l:config > 0
      let l:c = split(l:configs[l:config], ' ')
      let g:platform = l:c[1]
      let g:buildconfig = l:c[2]
    endif
  endfunction
  nnoremap <silent> <C-k><C-p> :call SetupProj()<CR>

  function! BuildProject(file)
    if len(a:file) == 0
      execute '!start python ' . $folscode ."/Python/BatchBuild/BuildCmd.py "
              \ . g:proj . ' --platform=' . g:platform . ' --configuration=' . g:buildconfig . ' --all-output'
      return
    endif
    let l:output = system("python ". $folscode ."/Python/BatchBuild/BuildCmd.py "
          \ . 'xxx' . ' --file="' . expand(a:file) . '" --platform=' . g:platform . ' --configuration=' . g:buildconfig)
    let l:errors = split(l:output, '\n')
    if len(l:errors) == 1
      echomsg l:errors[0]
    else
      let l:proj_path = remove(l:errors, 0)
      let l:qferrors = []
      for l:error in l:errors
        if len(l:error) == 0
            break
        endif
        let l:items = split(substitute(l:error,
                    \'^\%( \+\)\%(\d\+>\)\?\([^(]\+\)(\(\d\+\))\(.*\)',
                    \'\1|\2|\3', 'g'),
                    \'|')
        let l:qferror = {}
        if len(l:items) == 3
          let l:file = l:items[0]
          if l:file !~ '^\w:\'
            let l:file = l:proj_path . '\' . l:file
          endif
          let l:qferror['filename'] = l:file
          let l:qferror['lnum'] = l:items[1]
          let l:qferror['text'] = l:items[2]
        else
          let l:qferror['text'] = l:error
        endif
        call add(l:qferrors, l:qferror)
      endfor
      call setqflist(l:qferrors, 'r')
      if len(l:qferrors) == 0
        echomsg 'no error found~~~~~~'
      else
        cwindow
        crewind
      endif
    endif
  endfunction
  "nnoremap <silent> <C-k><C-b> :call BuildProject("")<CR>
  let g:proj='OriginAll'
  let g:platform='Win32'
  let g:buildconfig='Debug'

  function! ExecutePython()
    silent !start cmd.exe /C python %&pause
  endfunction

  nnoremap <silent> yq :let @+=substitute(expand('%:p'), '/', '\', 'g')<CR>
  nnoremap <silent> <C-k><C-b> :wall!<Bar>!mingw32-make<CR>
  nnoremap <silent> <C-k><C-v> :!mingw32-make clean<CR>
  set dictionary=~/vimfiles/mystuff/dict/3esl.txt
  set rtp+=~/vimfiles/bundle/Vundle.vim
  call vundle#rc('~/vimfiles/bundle/') 
else
  let g:proj=''
  let g:platform=''
  let g:buildconfig=''

  if has("gui_macvim")
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
    let g:clang_library_path="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/"
    set guifont=Microsoft_YaHei_Mono:h16

    nnoremap <silent> <F11> :silent !open %:p:h<CR>
    nnoremap <silent> <C-F11> :silent !open -a Terminal "%:p:h"<CR>
  else
    nnoremap <silent> <F11> :silent !xdg-open %:p:h<CR>
  endif

  function! BuildProject(file)
  endfunction

  function! ExecutePython()
    let l:tempfile = expand('~/vimbackup/python.sh')
    call writefile(['cd ' . expand('%:p:h'), 'python3 ' . expand('%')], l:tempfile)
    execute 'silent !chmod +x ' . l:tempfile
    execute 'silent !open -a Terminal ' . l:tempfile
  endfunction

  nnoremap <silent> yq :let @+=expand('%:p')<CR>
  nnoremap <silent> <C-k><C-b> :wall!<Bar>!make<CR>
  nnoremap <silent> <C-k><C-v> :!make clean<CR>
  set dictionary=~/.vim/mystuff/dict/3esl.txt
  set rtp+=~/.vim/bundle/Vundle.vim
endif

function! ExecuteCurrentFile()
  update
  if &filetype == 'python'
    cd %:p:h
    call ExecutePython()
  elseif &filetype == 'markdown'
    execute 'silent !"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "%:p"'
  elseif &filetype == 'dosbatch'
    silent !start cmd.exe /C %&pause
  else
    call BuildProject("%:p")
  endif
endfunction

imap <silent> <F11> <Esc><F11>
"" }}}
"" Indentation settings {{{
filetype indent plugin on
"" According to
"" http://stackoverflow.com/questions/18415492/autoindent-is-subset-of-smartindent-in-vim,
"" smartindent is deprecated and should not be used
set autoindent
"set smartindent
"" }}}
"" Turn on matchit {{{
runtime macros/matchit.vim
runtime macros/a.vim
"" }}}
"" NERDCommenter settings {{{
let NERDLPlace = '/*'
let NERDRPlace = '*/'
"" }}}
"" Gitv settings {{{
let g:Gitv_OpenPreviewOnLaunch = 0
let g:Gitv_CommitStep = 50
"" }}}
"" ctrlsf settings {{{
let g:ctrlsf_auto_close = 0
"" }}}

"" Auto commands for vim startup {{{
augroup VimStartup
  autocmd!
  "autocmd VimLeave * mksession! ~/vim_session
  "autocmd VimEnter * source ~/vim_session
  "autocmd VimEnter * :echo ">^.^<"
augroup END
"" }}}
"" Auto commands for FileType {{{
augroup FileTypeRelated
  autocmd!
  autocmd Filetype python :setlocal expandtab
  autocmd Filetype markdown :setlocal expandtab
  autocmd Filetype vim :setlocal tabstop=2 shiftwidth=2 expandtab foldmethod=marker
  autocmd Filetype lua :setlocal tabstop=2 shiftwidth=2 expandtab
augroup END
"" }}}
"" Auto commands for file reading {{{
augroup FileReadRelated
  autocmd!
  autocmd BufNewFile,BufRead
        \ *.vim,
        \*.h,*.hpp,*.c,*.cc,*.cpp,*.cxx,*.rc,
        \*.py,*.pyw,
        \*.rb,
        \*.java,*.js
        \ :setlocal nowrap
  "autocmd BufRead *.rc :edit ++encoding=cp1252
  autocmd BufNewFile,BufRead *.h,*.c,*.cpp :let b:tagbar_ignore = 1
  autocmd BufRead fugitive://* :set bufhidden=delete
  autocmd BufNewFile,BufRead *.oxf,*.vcxproj :set filetype=xml
augroup END
"" }}}
"" Auto commands for file writing {{{
augroup FileWriteRelated
  autocmd!
  "autocmd BufWritePost vimrc,.vimrc :source $MYVIMRC
  autocmd BufWritePre,FileWritePre *.* :call EnsureDirExists()
augroup END
"" }}}
"" Auto commands for buffering {{{
augroup BufferRelated
  autocmd!
  autocmd BufWinLeave * :call OnBufWinLeave()
  autocmd BufWinEnter * :call OnBufWinEnter()
  autocmd BufEnter * :call OnBufEnter()
  autocmd BufDelete * :call OnBufDelete()
augroup END
"" }}}
"" Something other commands {{{
command! Dowrap set wrap linebreak nolist
command! Nowrap set nowrap nolinebreak nolist
"" }}}

"" Vundle {{{
call vundle#begin()
Plugin 'tpope/vim-fugitive'
Plugin 'gregsexton/gitv'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/ctrlp.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'msanders/snipmate.vim'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'bronson/vim-visual-star-search'
Plugin 'tommcdo/vim-exchange'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'majutsushi/tagbar'
Plugin 'kshenoy/vim-signature'
Plugin 'dyng/ctrlsf.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
call vundle#end()
"" }}}

"" Colorscheme settings {{{
syntax enable
"colorscheme summerfruit256
let g:molokai_original = 1
colorscheme molokai
"" }}}

"" Statusline color settings {{{
hi User1 guifg=#ffdad8 guibg=#880c0e
hi User2 guifg=#000000 guibg=#F4905C
hi User3 guifg=#292b00 guibg=#f4f597
hi User4 guifg=#112605 guibg=#aefe7B
hi User5 guifg=#051d00 guibg=#7dcc7d gui=bold
hi User6 guifg=#ffffff guibg=#880c0e gui=bold
hi User7 guifg=#ffffff guibg=#5b7fbb
hi User8 guifg=#ffffff guibg=#810085
hi User9 guifg=#ffffff guibg=#094afe
"" }}}

"" Keymappings {{{
"nnoremap <silent> <Leader><Tab> :Scratch<CR>
nnoremap <silent> <Leader>tt    :tabedit<CR>
nnoremap <silent> <Leader>tr    :tabclose<CR>
nnoremap <silent> <Leader>a     :A<CR>
nnoremap <silent> <Leader>b     :CtrlPBuffer<CR>
nnoremap <silent> <Leader>f     :call CtrlPCurrentFolder()<CR>
nnoremap <silent> <Leader>v     :e $MYVIMRC<CR>
nnoremap <silent> <Leader>d     :bdelete<CR>
nnoremap <silent> <Leader>w     :update<CR>
nnoremap <silent> <Leader>n     :enew<CR>
nnoremap <Leader>ew             :e <C-R>=expand("%:p:h") . "/"<CR>
nnoremap <Leader>l              :set list!<Bar>set list?<CR>
nnoremap <Leader>s              :set spell!<Bar>set spell?<CR>
nnoremap <silent> <leader>gv    :Gitv --all --date-order<cr>
nnoremap <silent> <leader>gV    :Gitv! --all<cr>
vnoremap <silent> <leader>gV    :Gitv! --all<cr>

nnoremap <C-Tab> <Tab>

nmap <Tab> %
vmap <Tab> %

"set pastetoggle=<F3>

nnoremap <silent> <F1> :Gstatus<CR>
nnoremap <silent> <C-F1> :silent !start gitex.cmd browse "%:p"<CR>
nnoremap <silent> <S-F1> :silent !start gitex.cmd filehistory "%:p"<CR>
"nnoremap <F2> :NERDTreeToggle<CR>
"nnoremap <S-F2> :NERDTreeFind<CR>
nnoremap <silent> <F2> :call DiffCurrentFile('')<CR>
nnoremap <silent> <C-F2> :silent call DiffFile()<CR>
nnoremap <silent> <S-F2> :call DiffCurrentFile('--cached')<CR>
nnoremap <silent> <F3> :silent Git fetch --all<CR>
nnoremap <silent> <C-F3> :Git pull<CR>
nnoremap <silent> <S-F3> :Git push<CR>
nnoremap <silent> <F4> :silent Git add %<CR>
nnoremap <silent> <C-F4> :Gcommit<CR>
nnoremap <silent> <S-F4> :Gcommit --amend<CR>
"nnoremap <F5> :GundoToggle<CR>
nnoremap <silent> <F5> :silent !start gitex.cmd commit "%:p"<CR>
nnoremap <silent> <C-F5> :Gblame -w<CR>
nnoremap <silent> <S-F5> :Gread<bar>w!<CR>
"nmap <F6> <Plug>HexManager
nnoremap <F6> :e ++enc=cp1252
nnoremap <C-F6> :set fileencoding=utf8<Bar>set bomb
nnoremap <S-F6> /<C-R>*<CR>
"nnoremap <F7> :Bufferlist<CR>
nnoremap <silent> <F7> :call ExecuteCurrentFile()<CR>
nnoremap <silent> <C-F7> :call BuildProject('')<CR>
nnoremap <silent> <F8> :let b:tagbar_ignore = 0 \| TagbarToggle<CR>
nnoremap <silent> <F9> :call PEP8()<CR>
let g:init_columns = &columns
"nnoremap <silent> <F10> :call ReopenLastBuffer()<CR>
nnoremap <silent> <F10> :NERDTreeToggle<CR>
nnoremap <silent> <C-F10> :NERDTreeFind<CR>
nnoremap <silent> <S-F10> :let &columns=g:init_columns + 80 - &columns<CR>
nnoremap <silent> <F12> :silent Git add .<CR>
nnoremap <C-F12> :call RebaseThenPush()<CR><CR>
nnoremap <silent> <S-F12> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>


nnoremap \ <C-W>
nnoremap \\ <C-W><C-W>
nnoremap <C-S> :CtrlSFToggle<CR>


noremap <silent> <Esc> :noh<bar>pclose<bar>echo ''<CR><Esc>

nnoremap <silent> <C-k><C-o> :Gist -l<CR>
nnoremap <silent> <C-k><C-i> :CtrlPMRU<CR>
nnoremap <silent> <C-k><C-d> :Gdiff<CR>
"nnoremap <silent> <C-K><C-m> :call AddModificationLog()<CR>
nnoremap <silent> <C-l> :call AddCodeMarking()<CR>
vnoremap <silent> <C-l> :call AddCodeMarking()<CR>
nnoremap <silent> <C-k><C-j> :call SetupCodeMarking()<CR>
nnoremap <silent> <C-k><C-u> :call AddIfDef()<CR>
vnoremap <silent> <C-k><C-u> :call AddIfDef()<CR>
nnoremap <silent> <C-k><C-l> :call SurroundWithExceptionHandler()<CR>
vnoremap <silent> <C-k><C-l> :call SurroundWithExceptionHandler()<CR>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-k> <Left>
cnoremap <C-l> <Right>

nnoremap <silent> [a :previous<CR>
nnoremap <silent> ]a :next<CR>
nnoremap <silent> [A :first<CR>
nnoremap <silent> ]A :last<CR>

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

nnoremap <silent> [n :cprevious<CR>
nnoremap <silent> ]n :cnext<CR>
nnoremap <silent> [N :cfirst<CR>
nnoremap <silent> ]N :clast<CR>

nnoremap <Up> gk
nnoremap <Down> gj
nnoremap <silent> <C-Up> :cprevious<CR>
nnoremap <silent> <C-Down> :cnext<CR>
nnoremap <silent> <A-Up> [c
nnoremap <silent> <A-Down> ]c
nnoremap <silent> <A-Left> :call ChangeFontSize(-1)<CR>
nnoremap <silent> <A-Right> :call ChangeFontSize(1)<CR>

nnoremap <space> <C-F>
nnoremap <S-space> <C-B>
vnoremap <space> <C-F>
vnoremap <S-space> <C-B>
nnoremap <A-space> za
vnoremap <A-space> zf

nnoremap & "*
xnoremap & "*

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

vnoremap <silent> S<space> :call SurroundWithSpace()<CR>

nnoremap z. zz
nnoremap zz :silent NERDTreeClose<bar>normal ZZ<CR>
nnoremap Y y$
"" }}}

""
""
""
"" Custom functions
""
""
""
"" Setup codemarking {{{
function! SetupCodeMarking()
  let l:codemarks = split(input("Code Mark : "))
  let l:len = len(l:codemarks)
  if l:len > 1
      let g:jira = l:codemarks[0] . ' '
      let g:codem = l:codemarks[1]
  elseif l:len > 0
      let g:jira = ''
      let g:codem = l:codemarks[0]
  endif
endfunction
"" }}}
"" Add code marking to modification log, OrgLab stuff {{{
"function! AddModificationLog()
  "let l:temp = @/
	"g/ \*-\+\*\//normal! O*	Folger =strftime("%m/%d/%Y") =g:jira=g:codem
  "let @/ = l:temp
"endfunction
"" }}}
"" Add CodeMarking {{{
function! AddCodeMarking() range
  let l:fo = &formatoptions
  let l:ci = &cindent
  set formatoptions-=cro
  set nocindent
  execute a:firstline . "normal! O///------ Folger =strftime(\"%m/%d/%Y\") =g:jira=g:codem"
  execute a:lastline . "+1 normal! o///------ End =g:codem"
  let &formatoptions = l:fo
  let &cindent = l:ci
endfunction
"" }}}
"" Add IfDef {{{
function! AddIfDef() range
  let l:ci = &cindent
  let l:ai = &autoindent
  set nocindent
  set noautoindent
  execute a:lastline . "normal! o#endif /// =g:def"
  execute a:firstline . "normal! O#ifdef =g:def03l"
  let &cindent = l:ci
  let &autoindent = l:ai
endfunction
"" }}}
"" Pretty xml formatted current buffer {{{
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
  silent %!xmllint --format --encode utf-8 -
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
  execute "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
"" }}}
"" Pretty json formatted current buffer {{{
function! DoPrettyJSON()
  %!python -m json.tool
endfunction
command! PrettyJSON call DoPrettyJSON()
"" }}}
"" Put files in quickfix windows into args {{{
function! QuickfixFileNames()
  let buffer_names = {}
  for quickfix_item in getqflist()
    let buffer_names[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_names), 'fnameescape(v:val)'))
endfunction
command! -nargs=0 -bar Qargs execute 'args' QuickfixFileNames()
"" }}}
"" Toggle quickfix window {{{
let g:quickfix_is_open = 0
function! QuickfixToggle()
  if g:quickfix_is_open
    cclose
    let g:quickfix_is_open = 0
    execute g:quickfix_return_to_window . 'wincmd w'
  else
    let g:quickfix_return_to_window = winnr()
    copen
    let g:quickfix_is_open = 1
  endif
endfunction
nnoremap <silent> <Leader>q :call QuickfixToggle()<CR>
"" }}}
"" Toggle location window {{{
let g:location_is_open = 0
function! LocationToggle()
  if g:location_is_open
    lclose
    let g:location_is_open = 0
    execute g:quickfix_return_to_window . 'wincmd w'
  else
    let g:quickfix_return_to_window = winnr()
    lopen
    let g:location_is_open = 1
  endif
endfunction
nnoremap <silent> <Leader>o :call LocationToggle()<CR>
"" }}}
"" Using CtrlP to open current directory {{{
function! CtrlPCurrentFolder()
  let g:ctrlp_working_path_mode = 'c'
  CtrlP
  let g:ctrlp_working_path_mode = g:backup_ctrlp_working_path_mode
endfunction
"" }}}
"" Uniq command to remove duplicate lines {{{
function! MakeUniq() range
  let have_already_seen = {}
  let unique_lines = []
  let l:alllines = a:firstline == 1 && a:lastline == line('$')

  for original_line in getline(a:firstline, a:lastline)
    let normalized_line = '<' . original_line
    if !has_key(have_already_seen, normalized_line)
      call add(unique_lines, original_line)
      let have_already_seen[normalized_line] = 1
    endif
  endfor

  execute a:firstline . ',' . a:lastline . 'delete'
  call append(a:firstline-1, unique_lines)
  if l:alllines
    delete
  endif
endfunction
command! -range Uniq <line1>,<line2>call MakeUniq()
"" }}}
"" Save & Load sessions {{{
function! LoadSession(session)
    if len(a:session) > 0
      execute 'source ~/' . a:session . '.vim'
    endif
endfunction
function! SaveSession(session)
    if len(a:session) > 0
      execute 'mksession! ~/' . a:session . '.vim'
    endif
endfunction
command! -nargs=1 LS call LoadSession(<f-args>)
command! -nargs=1 SS call SaveSession(<f-args>)
"" }}}
"" Auto make directories {{{
function! EnsureDirExists()
  let required_dir = fnamemodify(expand('<afile>'), ':h')
  if len(required_dir) != 0
    if !isdirectory(required_dir)
      call mkdir(required_dir, 'p')
    endif
  end
endfunction
"" }}}
"" Change dos ending file to unix {{{
function! DoDOSEndingToUnix()
  edit ++fileformat=dos
  setlocal fileformat=unix
  write!
endfunction
command! -bar DOSEndingToUnix call DoDOSEndingToUnix()
"" }}}
"" Find symbol in tags file {{{
function! FindSymbolInTagsFile(tagspath)
  let l:key = input('Symbol Key : ')
  if len(l:key) <= 0
    return
  endif
  let l:pyfile = a:tagspath . 'FindSymbol.py'
  let l:symbols = system('python ' . l:pyfile . ' "' . l:key . '"')
  let allsymbols = []
  for l:symbol in split(l:symbols, '\n')
    let l:entries = split(l:symbol, '\t')
    call add(allsymbols, {'text':entries[0], 'filename':a:tagspath . l:entries[1], 'lnum':l:entries[2]})
  endfor
  call setqflist(l:allsymbols, 'r')
  cwindow
endfunction
nnoremap <c-k><c-x> :call FindSymbolInTagsFile(expand($develop) . '/.git/')<CR>
"" }}}
"" Git external diff tool to diff file {{{
function! DiffFile()
  let l:firstline = getline(1)
  if l:firstline =~ '^tree [0-9a-z]\+$'
    let l:line = getline(line('.') + 1)
    let l:hashes = split(l:line, ' ')
    if len(l:hashes) == 3
      "execute 'Git difftool -y ' l:hashes[1]
      let l:blobs = split(l:hashes[1], '\.\.')
      execute 'Git difftool -y ' . l:blobs[0] . ' ' . l:blobs[1]
    endif
  else
    let l:currentfile = expand('%:p')
    let l:gitindex = stridx(l:currentfile, '.git')
    if l:gitindex > 0
      if l:currentfile =~ '^fugitive'
        let l:gitpath = strpart(l:currentfile, 11, l:gitindex - 12)
      else
        let l:gitpath = strpart(l:currentfile, 0, l:gitindex - 1)
      endif
      let l:file = strpart(split(getline('.'), ' ')[2], 1)
      execute 'Git difftool -y "' . l:gitpath . l:file . '"'
    else
      execute 'Git difftool -y "%"'
    endif
  endif
endfunction
"" }}}
"" Show diff file using default($diff) diff tool {{{
let g:tempdiff=expand('~/vimbackup/temp.diff')
function! BCDiffFile()
  execute "1,$w! " . g:tempdiff
  execute '!"' . $diff . '" "' . g:tempdiff . '"'
endfunction
"" }}}
"" Surround selection with space {{{
function! SurroundWithSpace()
  let tmp = @z
  normal! gv"zy
  let @z = ' ' . @z . ' '
  normal! gv"zp
  let @z = tmp
endfunction
"" }}}
"" Buffer event {{{
function! OnBufWinLeave()
  let l:filename = expand('%:p')
  if len(l:filename) <= 0
    return
  endif

  " make view
  if !&bin && l:filename !~ '^fugitive' &&
            \ l:filename !~ '/\.git/index$' &&
            \ l:filename !~ 'gitv-\d' &&
            \ l:filename !~ g:tempdiff &&
            \ l:filename !~ '\[Vundle\]' &&
            \ l:filename !~ 'NERD_tree_' &&
            \ l:filename !~ '__CtrlSF__' &&
            \ l:filename !~ '__Tagbar__' &&
            \ l:filename !~ 'COMMIT_EDITMSG'
    mkview!
  end
endfunction
function! OnBufWinEnter()
  let l:filename = expand('%')
  if len(l:filename) <= 0
    return
  endif

  silent loadview

  "check file encoding
  if !&bin && filereadable(l:filename) && &fileencoding == ''
    echoerr 'File Encoding is NONE, reload with proper encoding before making any changes!!!'
  endif

  "map <CR> to update
  if &modifiable
    nnoremap <buffer> <silent> <CR> :update<CR>
  endif
endfunction
function! OnBufEnter()
  call RemoveFromLastBuffers()
endfunction
function! OnBufDelete()
  call AddLastBuffer()
endfunction
"" }}}
"" Show Diff File for Current file {{{
function! DiffCurrentFile(arg)
  let l:file = expand('%:p')
  let l:dir = expand('%:p:h')
  let l:oldDir = getcwd()
  execute 'cd ' . l:dir
  execute 'new | read !git diff ' . a:arg . ' -- "' . l:file . '"'
  1delete
  execute 'write! ' g:tempdiff
  view
  setlocal nomodifiable
  setlocal previewwindow
  setlocal bufhidden=delete
  1
  execute 'cd ' l:oldDir
endfunction
"" }}}
"" PEP8 {{{
function! PEP8()
  if &filetype == 'python'
    update
    let l:filename = expand('%')
    let l:output = system("pep8 --ignore=E116 " . l:filename)
    let l:errors = split(l:output, '\n')
    let l:qferrors = []
    for l:error in l:errors
      let l:items = split(substitute(l:error,
                  \'^.\{-}\(\d\+\):\(\d\+\): \(.*\)$',
                  \'\1|\2|\3', 'g'),
                  \'|')
      let l:qferror = {}
      if len(l:items) == 3
        let l:qferror['filename'] = l:filename
        let l:qferror['lnum'] = l:items[0]
        let l:qferror['col'] = l:items[1]
        let l:qferror['text'] = l:items[2]
      else
        let l:qferror['text'] = l:error
      endif
      call add(l:qferrors, l:qferror)
    endfor
    call setqflist(l:qferrors, 'r')
    if len(l:qferrors) == 0
      echomsg 'GOOOOOOOOD PEP8 ~~~~~~'
    else
      cwindow
      crewind
    endif
  else
    echomsg 'Not a python file~~'
  endif
endfunction
"" }}}
"" Surround code with Exception Handler {{{
function! SurroundWithExceptionHandler() range
  if &filetype == 'python'
    execute a:firstline . "normal! Otry:"
    execute a:lastline . "+1 normal! oexcept:pass"
    execute a:firstline . "+1," . a:lastline . "+1 normal! >>"
  else
    execute a:firstline . "normal! Otry{"
    execute a:lastline . "+2 normal! o}catch (...){}"
    execute a:firstline . "+2," . a:lastline . "+2 normal! >>"
  endif
endfunction
"" }}}
"" Increase/Descrease font size {{{
"function! ChangeFontSize(delta)
  "let l:fonts = split(&guifont, ':')
  "let l:fontsize = str2nr(l:fonts[1][1:])
  "let l:fontsize += a:delta
  "let &guifont = l:fonts[0] . ':h' . string(l:fontsize)
  "echoerr &guifont
"endfunction
"" }}}
"" Fill Quickfix window with xcode wanrings/errors {{{
"function! XcodeFillQuickfixWindow() range
  "let l:qferrors = []
  "for line in getline(a:firstline, a:lastline)
    "let l:items = split(line, ':')
    "let l:qferror = {}
    "let l:offset = -1
    "if len(l:items) == 4
      "let l:offset = 0
    "elseif len(l:items) == 5
      "let l:offset = 1
    "endif
    "if l:offset >= 0
      "if l:offset == 1
        "let l:qferror['filename'] = join(l:items[:1], ':')
      "else
        "let l:qferror['filename'] = l:items[0]
      "endif
      "let l:qferror['lnum'] = l:items[l:offset+1]
      "let l:qferror['col'] = l:items[l:offset+2]
      "let l:qferror['text'] = l:items[l:offset+3]
      "call add(l:qferrors, l:qferror)
    "endif
  "endfor
  "call setqflist(l:qferrors, 'r')
  "if len(l:qferrors) != 0
    "cwindow
    "crewind
  "endif
"endfunction
"" }}}
"" Fill Quickfix window with VC find results {{{
function! DoVCFindFillQuickfixWindow()
  let l:qferrors = []
  for line in split(@+, '\n')
    let l:items = split(substitute(line,
                \'^  \(.\{-}\)(\(\d\+\)):\(.*\)$',
                \'\1|\2|\3', 'g'),
                \'|')
    if len(l:items) != 3
      continue
    endif

    let l:qferror = {}
    let l:qferror['filename'] = l:items[0]
    let l:qferror['lnum'] = l:items[1]
    let l:qferror['text'] = l:items[2]
    call add(l:qferrors, l:qferror)
  endfor
  call setqflist(l:qferrors, 'r')
  if len(l:qferrors) != 0
    cwindow
    crewind
  endif
endfunction
command! VCFindFillQuickfixWindow call DoVCFindFillQuickfixWindow()
"" }}}
"" Reopen last buffer {{{
let g:lastbuffers = []
function! AddLastBuffer()
  let l:lastbuffer = expand('%:p')
  if len(l:lastbuffer) > 0 &&
    \ l:lastbuffer !~ '^fugitive' &&
    \ l:lastbuffer !~ '/\.git/index$' &&
    \ !&previewwindow &&
    \ index(g:lastbuffers, l:lastbuffer) < 0
    call add(g:lastbuffers, l:lastbuffer)
  endif
endfunction
function! RemoveFromLastBuffers()
  let l:index = index(g:lastbuffers, expand('%:p'))
  if l:index >= 0
    call remove(g:lastbuffers, l:index)
  endif
endfunction
function! ReopenLastBuffer()
  let l:size = len(g:lastbuffers)
  if l:size > 0
    execute 'edit ' . g:lastbuffers[l:size-1]
  endif
endfunction
"" }}}
"" Git Rebase on master then push {{{
function! RebaseThenPush()
  if fugitive#head(7) != 'master'
    echoerr 'Current branch is not master, cannot rebase and push !!!'
    return
  endif
  let l:dir = expand('%:p:h')
  let l:oldDir = getcwd()
  execute 'cd ' . l:dir
  execute '!git fetch --all &&' .
          \' git checkout master &&' .
          \' git rebase origin/master &&' .
          \' git push origin master'
  execute 'cd ' . l:oldDir
endfunction
"" }}}
"" Statusline build info {{{
function! BuildInfo()
  if g:proj == ''
    return ''
  endif
  return g:platform . ' - ' . g:buildconfig . ' - '. g:proj
endfunction
"" }}}
"" Reverse text in line {{{
function! Reversed() range
  let reversed_lines = []
  let l:alllines = a:firstline == 1 && a:lastline == line('$')
  for original_line in getline(a:firstline, a:lastline)
    call add(reversed_lines, join(reverse(split(original_line, '.\zs')), ''))
  endfor
  execute a:firstline . ',' . a:lastline . 'delete'
  call append(a:firstline-1, reversed_lines)
  if l:alllines
    delete
  endif
endfunction
command! -range Rev <line1>,<line2>call Reversed()
"" }}}
"" DoCtrlSF {{{
function! DoCtrlSF(args)
  let l:old = &shellslash
  let &shellslash = 0
  silent call ctrlsf#Search(a:args, 0) 
  let &shellslash = l:old
endfunction
com! -n=* -comp=customlist,ctrlsf#comp#Completion CS call DoCtrlSF(<q-args>)
"" }}}
