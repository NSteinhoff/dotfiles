source ~/.vimrc

augroup settings
    autocmd!
    " Source this file on write
    autocmd BufWritePost .vimrc,vimrc,init.vim source <sfile>
augroup END


" --------------------------------- UI -----------------------------------{{{
set splitright
set laststatus=2
set inccommand=split

"}}}


" -------------------------------- Searching ----------------------------------{{{
set wildignore+=*/target/*

if executable('rg')
    command! -nargs=+ Rg cexpr system('rg --vimgrep --smart-case '.<q-args>)
endif
if executable('ag')
    command! -nargs=+ Ag cexpr system('ag --vimgrep --smart-case '.<q-args>)
endif
" }}}


" ---------------------------------- Colors -----------------------------------{{{

" Gracefully handle unavailable colorscheme. The desired colorscheme
" might not be installed yet. This happens after cloning and installing
" the dotfiles for the first time. Otherwise you'd have to click through
" the error messages manually.
try
    colorscheme minimal
    set background=dark
catch E185
    echo "Colorscheme not installed. Using the default colorscheme."
    colorscheme default
    set background=dark
endtry

"}}}


" ------------------------------- Autoread -------------------------------------{{{

set autoread
augroup autoread_settings
    autocmd!
    " check for file modification and trigger realoading
    autocmd CursorHold * silent! checktime
augroup END

"}}}


" ----------------------------------- Tags -----------------------------------{{{

" Upward search from current file, then 'tags' in the working directory
" -> files dir (./xyz)
" -> upwards from file (./xyz;)
" -> cwd (xyz)
" -> upwards from cwd (xyz;)
" plain tags -> .git/tags
set tags=./tags,./tags;,tags,tags;

" I've set up a git hook that get's installed for all repositories that
" creates tags files on git actions that change the index (commits,
" checkouts, merges, etc.). This file lives in the .git/ directory.
set tags+=./.git/tags,./.git/tags;,.git/tags,.git/tags;
augroup tags
    autocmd!
    " FileType specific tags
    " autocmd FileType scala,rust,python if exists('&tagfunc') | set tagfunc=myfuncs#fttags  | endif
augroup END


"}}}


" ------------------------------- Error Files ---------------------------------{{{
augroup errorfiles
    autocmd!
    " Set the compiler to the root of an errorfile
    " sbt.err -> :compiler sbt
    " flake8.err -> :compiler flake8
    autocmd BufReadPost *.err execute "compiler " . expand("<afile>:r") | cgetbuffer
augroup END
" }}}


" ---------------------------------- Commands --------------------------------{{{
" Align text
" Using 'sed' and 'column' external tools
command! -range Align <line1>,<line2>!sed 's/\s\+/~/g' | column -s'~' -t
command! -nargs=1 -range AlignOn <line1>,<line2>!sed 's/\s\+<args>/ ~<args>/g' | column -s'~' -t

" Headers
command! -nargs=? Section call myfuncs#section(<q-args>)
command! -nargs=? Header call myfuncs#header(<q-args>)

command! Compiler call compiler#describe()
command! -nargs=1 -complete=compiler CompileWith call compiler#with(<f-args>)

" Edit my filetype/syntax plugin files for current filetype.
command! -nargs=? -complete=compiler EditCompiler
    \ exe 'keepj edit $HOME/.vim/after/compiler/' . (empty(<q-args>) ? compiler#which() : <q-args>) . '.vim'

command! -nargs=? -complete=filetype EditFiletype
    \ exe 'keepj edit $HOME/.vim/after/ftplugin/' . (empty(<q-args>) ? &filetype : <q-args>) . '.vim'

command! -nargs=? -complete=filetype EditSyntax
    \ exe 'keepj edit $HOME/.vim/after/syntax/' . (empty(<q-args>) ? &filetype : <q-args>) . '.vim'

command! -nargs=? -complete=color EditColorscheme
    \ execute 'keepj edit $HOME/.vim/after/colors/' . (empty(<q-args>) ? g:colors_name : <q-args>) . '.vim'
"}}}


" --------------------------------- Mappings ---------------------------------{{{

" Move over visual lines unless a count is given
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Hard Mode
" nnoremap h <NOP>
" nnoremap j <NOP>
" nnoremap k <NOP>
" nnoremap l <NOP>
" vnoremap h <NOP>
" vnoremap j <NOP>
" vnoremap k <NOP>
" vnoremap l <NOP>
" nnoremap <BS> <NOP>
" vnoremap <BS> <NOP>
" inoremap <BS> <NOP>

" Navigate Windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
set wildcharm=<C-Z>

" Window resizing with the arrow keys
map  <right>  5<c-w>>  "  increase  width
map  <left>   5<c-w><  "  decrease  width
map  <up>     5<c-w>+  "  increase  height
map  <down>   5<c-w>-  "  decrease  height

" Faster scrolling
nnoremap <c-e> 3<c-e>
nnoremap <c-y> 3<c-y>

" Clear search highlights
if maparg('<ESC>', 'n') ==# ''
    nnoremap <silent> <ESC> :nohlsearch<CR>
endif
if maparg('<SPACE>', 'n') ==# ''
    nnoremap <silent> <SPACE> :nohlsearch<CR>
endif

" CTRL-s and <F5> make the project
nnoremap <F5> :make!<cr>
nnoremap <c-s> :make<cr>

" Display Quickfix items
nnoremap Q :clist<cr>
" Next error
nnoremap <c-q> :cnext<cr>

" Preview word under cursor
nnoremap <C-Space> <c-w>}
" Preview selection
vnoremap <C-Space> y:ptag<C-r>"<cr>
" Close the preview window
nnoremap <backspace> <c-w>z


" ------------------------ Cycling lists with ] and [ -------------------------
nnoremap [a :previous<cr>
nnoremap ]a :next<cr>

nnoremap [b :bprevious<cr>
nnoremap ]b :bnext<cr>
nnoremap <c-p> :bprevious<cr>
nnoremap <c-n> :bnext<cr>

nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>

nnoremap [l :lprevious<cr>
nnoremap ]l :lnext<cr>

nnoremap [t :tprevious<cr>
nnoremap ]t :tnext<cr>

nnoremap [p :ptprevious<cr>
nnoremap ]p :ptnext<cr>

nnoremap [u :earlier<cr>
nnoremap ]u :later<cr>

" --------------------------------- <LEADER> ----------------------------------
"
" - Mappings for the most used commands
" - Don't replace builtin mappings except for the preview tags (those are terrible)
"

" Quick Keys
vnoremap <leader>a :Align<cr>
nnoremap <leader>! :!%:p<cr>
nnoremap <leader>x :. w !bash<cr>
vnoremap <leader>x :w !bash<cr>
nnoremap <leader>b :buffer <C-Z>
nnoremap <leader>v :vert sbuffer <C-Z>
nnoremap <leader>t :tab sbuffer <C-Z>
nnoremap <leader>e :edit **/*
nnoremap <leader>f :find **/*
nnoremap <leader>c :edit $MYVIMRC<cr>

" File Explorer
nnoremap <leader>E :Explore<cr>
nnoremap <leader>V :Vexplore<cr>
nnoremap <leader>T :Texplore<cr>
"}}}


" ---------------------------------- Netrw ------------------------------------{{{
" Hide files that are ignored by git
let  g:netrw_list_hide  =  netrw_gitignore#Hide()
let  g:netrw_preview    =  1
let  g:netrw_altv       =  1
let  g:netrw_alto       =  0
"}}}


" --------------------------------- Plugins ----------------------------------{{{

" Personal plugins
packadd! statusline
" packadd! differ
" packadd! pomodoro

" Install minpac as an optional package if it's not already installed.
let minpac_path = has('nvim') ? '~/.config/nvim/pack/minpac/opt/minpac' : '~/.vim/pack/minpac/opt/minpac'
let minpac_source = 'https://github.com/k-takata/minpac.git'
if empty(glob(minpac_path)) | exe 'silent !git clone '.minpac_source.' '.minpac_path | endif

" Minpac is only needed when doing changes to the plugins such as updating
" or deleting.
"
" Instead the commands below add the package on demand.
if exists('*minpac#init')
    call minpac#init()
    " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " |||                   |||
    " ||| Add plugins below |||
    " vvv                   vvv

    " REPL:
    " Tmux based REPL integration using 'tslime'
    call minpac#add('jgdavey/tslime.vim')

    " Clojure:
    " nRepl integration
    " call minpac#add('bhurlow/vim-parinfer')
    " call minpac#add('tpope/vim-fireplace')

    " FTPlugings:
    " call minpac#add('sheerun/vim-polyglot')
    call minpac#add('vim-python/python-syntax')
    call minpac#add('Vimjas/vim-python-pep8-indent')

    " Language Server:
    " call minpac#add('neovim/nvim-lsp')

    " Tagbar
    call minpac#add('majutsushi/tagbar')
endif

" Load all packages in 'start/'
packloadall

" These commands load minpac on demand and get the list of plugins by sourcing this file
" before calling the respective minpac function for that task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()


" Plugin Configuration:

" vim-python
let g:python_highlight_all = 1

" Tslime
vmap  <C-c><C-c>  <Plug>SendSelectionToTmux
nmap  <C-c><C-c>  <Plug>NormalModeSendToTmux
nmap  <C-c>r      <Plug>SetTmuxVars

" Tagbar
if exists(':TagbarToggle')
    nnoremap <leader><backspace> :silent TagbarToggle<cr>
endif

"}}}


" ------------------------------ Abbreviations -------------------------------- {{{
" Last modification date of the current file
iabbrev <expr> ddf strftime("%c", getftime(expand('%')))
" Local date-time
iabbrev <expr> ddc strftime("%c")
" Local date
iabbrev <expr> ddd strftime("%Y-%m-%d")
"}}}


" vim:foldmethod=marker textwidth=0
