"" basic settings {{{
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

set go-=m ""remove the menu bar
set go-=T ""remove the toolbar

"set relativenumber
set cursorline
set backspace=2 ""make backspace work like most other apps
"set number

set hlsearch
set incsearch
set showmatch
set tabstop=4
set shiftwidth=4

set laststatus=2  "" Always show the statusline

set ignorecase
set smartcase

set encoding=utf-8
let &termencoding=&encoding
set fileencodings=ucs-bom,utf-8,sjis,gbk
set ambiwidth=double

set dictionary=~/vimfiles/mystuff/dict/3esl.txt
"" }}}

"" CtrlP settings {{{
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
"" clang_complet {{{
let g:clang_complete_loaded=1
"let g:clang_auto_select = 2
"let g:clang_complete_copen=1
"let g:clang_periodic_quickfix=1
"let g:clang_snippets=1
let g:clang_use_library=1
let g:clang_close_preview=1
let g:clang_user_options='-stdlib=libc++ -std=c++11 -IIncludePath'
"" }}}
"" syntastic settings {{{
let g:syntastic_ignore_files = ['\m\c\.py$', '\m\c\.pyw$']
"" }}}
"" pymode settings {{{
let g:pymode_python = 'python'
let g:pymode_rope = 0
let g:pymode_lint_ignore = "E501,E265,C901"
let g:pymode_breakpoint_bind = ''
"" }}}
"" tagbar settings {{{
let g:tagbar_autofocus = 1
"" }}}
"" NERDTree settings {{{
let g:NERDTreeHijackNetrw = 0
"" }}}
"" adjust configuration for such hostile environment as Windows, and others {{{
if has("win32") || has("win16")
  set lines=35 columns=100
  let g:tagbar_ctags_bin = 'D:\clang_lib\ctags.exe'
  let g:clang_library_path="D:/clang_lib/"
  set guifont=DejaVu_Sans_Mono:h10
  set guifontwide=NSimSun:h10

  function! OpenContaningFolder()
    let l:path = substitute(expand('%:p:h'), '/', '\', 'g')
    execute "silent !start explorer /e," . l:path
  endfunction
  nnoremap <silent> <S-F11> :call OpenContaningFolder()<CR>
  function! RevealFileInFolder()
    let l:path = substitute(expand('%:p'), '/', '\', 'g')
    execute "silent !start explorer /select," . l:path
  endfunction
  nnoremap <silent> <F11> :call RevealFileInFolder()<CR>

  function! SetupProj()
    let l:proj = input('Project/Solution name : ')
    if len(l:proj) > 0
      let g:proj = l:proj
    endif
  endfunction
  nnoremap <silent> <C-k><C-p> :call SetupProj()<CR>

  function! BuildProject(file)
    let l:output = system("python ". $Checkcode ."/Python/BuildProj/BuildCmd.py "
          \ . g:proj . " " . expand(a:file))
    let l:errors = split(l:output, '\n')
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
  endfunction
  "nnoremap <silent> <C-k><C-b> :call BuildProject("")<CR>


  nnoremap <silent> yq :let @+=substitute(expand('%:p'), '/', '\', 'g')<CR>
  nnoremap <silent> <C-k><C-b> :wall!<Bar>!mingw32-make<CR>
  nnoremap <silent> <C-k><C-v> :!mingw32-make clean<CR>
else
  if has("gui_macvim")
    let g:tagbar_ctags_bin = '/opt/local/bin/ctags'
    let g:clang_library_path="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/"
    set guifont=DejaVu_Sans_Mono:h12

    nnoremap <silent> <F11> :!open %:p:h<CR>
  else
    nnoremap <silent> <F11> :!xdg-open %:p:h<CR>
  endif

  function! BuildProject(file)
  endfunction

  nnoremap <silent> yq :let @+=expand('%:p')<CR>
  nnoremap <silent> <C-k><C-b> :wall!<Bar>!make<CR>
  nnoremap <silent> <C-k><C-v> :!make clean<CR>
endif

function! CompileCurrentFile()
  update
  if &filetype == 'python'
    !python %
  else
    call BuildProject("%:t")
  endif
endfunction

imap <silent> <F11> <Esc><F11>
"" }}}
"" indentation settings {{{
filetype indent plugin on
"" according to
"" http://stackoverflow.com/questions/18415492/autoindent-is-subset-of-smartindent-in-vim,
"" smartindent is deprecated and should not be used
set autoindent
"set smartindent
"" }}}
"" turn on matchit {{{
runtime macros/matchit.vim
"" }}}
"" airline settings {{{
let g:airline#extensions#tabline#enabled = 1
"" }}}
"" YankRing settings {{{
let g:yankring_replace_n_pkey = ''
let g:yankring_replace_n_nkey = ''
"" }}}
"" solarized settings {{{
let g:solarized_italic = 0
"" }}}
"" NERDCommenter settings {{{
let NERDLPlace = '/*'
let NERDRPlace = '*/'
"" }}}
"" gitv settings {{{
let g:Gitv_OpenPreviewOnLaunch = 0
let g:Gitv_CommitStep = 50
"" }}}

"" auto commands for vim startup {{{
augroup VimStartup
  autocmd!
  "autocmd VimLeave * mksession! ~/vim_session
  "autocmd VimEnter * source ~/vim_session
  autocmd VimEnter * :echo ">^.^<"
augroup END
"" }}}
"" auto commands for FileType {{{
augroup FileTypeRelated
  autocmd!
  autocmd Filetype python :setlocal expandtab
  autocmd Filetype vim :setlocal tabstop=2 shiftwidth=2 expandtab foldmethod=marker
  autocmd Filetype lua :setlocal tabstop=2 shiftwidth=2 expandtab
augroup END
"" }}}
"" auto commands for file reading {{{
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
  autocmd BufReadPost fugitive://* :set bufhidden=delete
augroup END
"" }}}
"" auto commands for file writing {{{
augroup FileWriteRelated
  autocmd!
  "autocmd BufWritePost vimrc,.vimrc :source $MYVIMRC
  autocmd BufWritePre,FileWritePre *.* :call EnsureDirExists()
augroup END
"" }}}
"" auto commands for buffering {{{
augroup BufferRelated
  autocmd!
  autocmd BufWinLeave *.* :call MakeView()
  autocmd BufWinEnter *.* :silent loadview
augroup END
"" }}}
"" something other commands {{{
command! Dowrap set wrap linebreak nolist
command! Nowrap set nowrap nolinebreak nolist
"" }}}
"" commands abbreviation {{{
cabbrev git Git
"" }}}

execute pathogen#infect()

"" colorscheme settings {{{
syntax enable
set background=light
colorscheme summerfruit256
"" }}}

"" keymappings {{{
nnoremap <silent> <Leader><Tab> :Scratch<CR>
nnoremap <silent> <Leader>tt    :tabedit<CR>
nnoremap <silent> <Leader>tr    :tabclose<CR>
nnoremap <silent> <Leader>b     :CtrlPBuffer<CR>
nnoremap <silent> <Leader>f     :call CtrlPCurrentFolder()<CR>
nnoremap <silent> <Leader>v     :e $MYVIMRC<CR>
nnoremap <silent> <Leader>d     :bd<CR>
nnoremap <silent> <Leader>w     :update<CR>
nnoremap <silent> <Leader>n     :enew<CR>
nnoremap <Leader>ew             :e <C-R>=expand("%:p:h") . "/"<CR>
nnoremap <Leader>l              :set list!<Bar>set list?<CR>
nnoremap <Leader>s              :set spell!<Bar>set spell?<CR>
nnoremap <leader>gv             :Gitv --all --date-order<cr>
nnoremap <leader>gV             :Gitv! --all<cr>
vnoremap <leader>gV             :Gitv! --all<cr>

nnoremap <C-Tab> <Tab>

nmap <Tab> %
vmap <Tab> %

set pastetoggle=<F3>

nnoremap <C-F3> :Git fetch --all<CR>
nnoremap <F4> :Gblame -w<CR>
nnoremap <F5> :GundoToggle<CR>
nmap <F6> <Plug>HexManager
"nnoremap <F7> :Bufferlist<CR>
nnoremap <silent> <F7> :call CompileCurrentFile()<CR>
noremap \ <C-W>

nnoremap <F1> :Gstatus<CR>
nnoremap <C-F1> :e ++enc=cp1252<CR>
nnoremap <S-F1> :call BCDiffFile()<CR>
"nnoremap <F2> :NERDTreeToggle<CR>
"nnoremap <S-F2> :NERDTreeFind<CR>
nnoremap <F2> :Git difftool % -y<CR>
nnoremap <S-F2> :Git mergetool % -y<CR>
nnoremap <C-F2> :call DiffFile()<CR>
nnoremap <F8> :let b:tagbar_ignore = 0 \| TagbarToggle<CR>

noremap <Esc> :noh<bar>pclose<CR><Esc>

nnoremap <C-K><C-o> :Gist -l<CR>
nnoremap <C-k><C-i> :CtrlPMRU<CR>
nnoremap <C-k><C-d> :Gdiff<CR>
nnoremap <C-K><C-m> :call AddModificationLog()<CR>
nnoremap <C-k><C-l> :call AddCodeMarking()<CR>
vnoremap <C-k><C-l> :call AddCodeMarking()<CR>
nnoremap <C-k><C-j> :call SetupCodeMarking()<CR>
nnoremap <C-k><C-u> :call AddIfDef()<CR>
vnoremap <C-k><C-u> :call AddIfDef()<CR>

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

"nnoremap j gj
"nnoremap k gk

nnoremap <space> za
vnoremap <space> za

nnoremap & :&&<CR>
xnoremap & :&&<CR>

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

vnoremap <silent> S<space> :call SurroundWithSpace()<CR>
"" }}}

"" repeat commands {{{
"nnoremap <silent> <Plug>TransposeCharacters xp
            "\:call repeat#set("\<Plug>TransposeCharacters")<CR>
"nmap cp <Plug>TransposeCharacters
"" }}}

""
""
""
"" Custom functions
""
""
""
"" setup codemarking {{{
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
"" add code marking to modification log, OrgLab stuff {{{
function! AddModificationLog()
  let l:temp = @/
	g/ \*-\+\*\//normal! O*	Folger =strftime("%m/%d/%Y") =g:jira=g:codem
  let @/ = l:temp
endfunction
"" }}}
"" add CodeMarking {{{
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
"" add IfDef {{{
function! AddIfDef() range
  let l:ci = &cindent
  let l:ai = &autoindent
  set nocindent
  set noautoindent
  execute a:firstline . "normal! O#ifdef =g:define"
  execute a:lastline . "+1 normal! o#endif /// =g:define"
  let &cindent = l:ci
  let &autoindent = l:ai
endfunction
"" }}}
"" pretty xml formatted current buffer {{{
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
  execute "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
"" }}}
"" put files in quickfix windows into args {{{
function! QuickfixFileNames()
  let buffer_names = {}
  for quickfix_item in getqflist()
    let buffer_names[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_names), 'fnameescape(v:val)'))
endfunction
command! -nargs=0 -bar Qargs execute 'args' QuickfixFileNames()
"" }}}
"" toggle quickfix window {{{
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
"" using CtrlP to open current directory {{{
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

  for original_line in getline(a:firstline, a:lastline)
    let normalized_line = '<' . original_line
    if !has_key(have_already_seen, normalized_line)
      call add(unique_lines, original_line)
      let have_already_seen[normalized_line] = 1
    endif
  endfor

  execute a:firstline . ',' . a:lastline . 'delete'
  call append(a:firstline-1, unique_lines)
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
"" change dos ending file to unix {{{
function! DoDOSEndingToUnix()
  edit ++fileformat=dos
  setlocal fileformat=unix
  write!
endfunction
command! -bar DOSEndingToUnix call DoDOSEndingToUnix()
"" }}}
"" find symbol in tags file {{{
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
  if l:firstline =~ '^tree '
    let l:line = getline(line('.') + 1)
    let l:hashes = split(l:line, ' ')
    if len(l:hashes) == 3
      execute 'Git difftool -y ' l:hashes[1]
    endif
  else
    let l:currentfile = expand('%:p')
    if l:currentfile =~ '^fugitive'
      let l:gitpath = strpart(l:currentfile, 11, stridx(l:currentfile, '.git') - 12)
    else
      let l:gitpath = strpart(l:currentfile, 0, stridx(l:currentfile, '.git') - 1)
    endif
    let l:file = strpart(split(getline('.'), ' ')[2], 1)
    execute 'Git difftool -y ' l:gitpath . l:file
  endif
endfunction
"" }}}
"" show diff file using default($diff) diff tool {{{
function! BCDiffFile()
  execute "1,$w! ~/vimbackup/temp.diff"
  execute '!"' . $diff . '" ' . $home . '/vimbackup/temp.diff'
endfunction
"" }}}
"" Make file view {{{
function! MakeView()
  let filename = expand('%')
  if filename =~ '^fugitive'
    return
  end
  mkview!
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
