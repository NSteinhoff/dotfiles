source ~/.vimrc

augroup settings
    autocmd!
    " Source this file on write
    autocmd BufWritePost .vimrc,vimrc,init.vim source <sfile>
augroup END


" --------------------------------- UI -----------------------------------{{{
set inccommand=split
set rulerformat=%25(%l,%c%V%M%=%P\ %y%)
"}}}

" --------------------------------- Editing -----------------------------------{{{
set wrap
set linebreak
set breakindent
let &showbreak = '... '
set showmatch
" }}}


" -------------------------------- Searching ----------------------------------{{{
set wildignore+=*/target/*

if executable('rg')
    command! -nargs=+ Rg cexpr system('rg --vimgrep --smart-case '.<q-args>)
    nnoremap <leader>rg :execute 'Rg '.expand('<cword>')<CR>
endif
if executable('ag')
    command! -nargs=+ Ag cexpr system('ag --vimgrep --smart-case '.<q-args>)
    nnoremap <leader>ag :execute 'Ag '.expand('<cword>')<CR>
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

command! -range Run echo join(map(getline(<line1>, <line2>), { k, v -> trim(system(v)) }), "\n")

" Git commands
command! -range Blame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")
command! -bar -nargs=+ Jump cexpr system('git jump ' . expand(<q-args>))
"}}}


" --------------------------------- Mappings ---------------------------------{{{
" Free:
" <BACKSPACE>
" <C-S>
" <> (formatting?)
"
" <C-J> (forward, down)
" <C-K> (back, up, keyword)
" <C-L> (forward, right)
" <C-H> (forward, left, home)
"
" z<SPACE> (folding?, scrolling?)

" Move over visual lines unless a count is given
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Scrolling the window with CTRL-HJKL
nnoremap <C-J> 3<C-E>
nnoremap <C-K> 3<C-Y>
nnoremap <C-H> 3zh
nnoremap <C-L> 3zl

" Window resizing with the arrow keys
map  <left>   5<C-W><  "  decrease  width
map  <right>  5<C-W>>  "  increase  width
map  <up>     5<C-W>+  "  increase  height
map  <down>   5<C-W>-  "  decrease  height

" Faster scrolling
nnoremap <C-E> 3<C-E>
nnoremap <C-Y> 3<C-Y>

" --- Clear search highlights ---
if maparg('<ESC>', 'n') ==# ''
    nnoremap <silent> <ESC> :nohlsearch<CR>
endif
if maparg('<SPACE>', 'n') ==# ''
    nnoremap <silent> <SPACE> :nohlsearch<CR>
endif

" --- :make ---
" m<SPACE> and <F5> make the project
nnoremap <F5> :make!<CR>
nnoremap m<SPACE> :make<CR>

" --- Errors: Quickfix / Location Lists ---
" Display
nnoremap Q :clist<CR>

" --- Preview ---
" Preview word under cursor
nnoremap <C-SPACE> <C-W>}
" Preview selection
vnoremap <C-SPACE> y:ptag<C-R>"<CR>
" Close the preview window
nnoremap <C-W><C-SPACE> <C-W>z
" Complete tag
inoremap <C-SPACE> <C-X><C-]>


" --- Cycling ---
" Quickly cycling a list
" (currently Buffers)
nnoremap <C-P> :bprevious<CR>
nnoremap <C-N> :bnext<CR>

" --- Toggle Settings ---
" Exetending 'vim-unimpaired'
" T: s(T)atusbar
nnoremap <silent> [ot :set ls=2<CR>
nnoremap <silent> ]ot :set ls=0<CR>
nnoremap <expr> <silent> yot (&laststatus == 2 ? ':set ls=0<CR>' : ':set ls=2<CR>')

" --------------------------------- <LEADER> ----------------------------------
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'
set wildcharm=<C-Z>

" Quick Keys
vnoremap <leader>\| :Align<CR>
nnoremap <leader>! :!%:p<CR>
nnoremap <leader>x :Run<CR>
vnoremap <leader>x :Run<CR>
nnoremap <leader>m :make<CR>

nnoremap <leader>a :argadd <C-R>=fnameescape(expand('%:p:h'))<CR>/*<C-Z>
nnoremap <leader>e :edit **/<C-Z>
nnoremap <leader>f :find **/<C-Z>
nnoremap <leader>b :buffer <C-Z>
nnoremap <leader>v :vert sbuffer <C-Z>
nnoremap <leader>t :tab sbuffer <C-Z>

nnoremap <leader>c :edit $MYVIMRC<CR>

" File Explorer
nnoremap <leader>E :Explore<CR>
nnoremap <leader>V :Vexplore<CR>
nnoremap <leader>T :Texplore<CR>

" ---------------------------------- Unused -----------------------------------
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
" nnoremap <C-J> <C-W>j
" nnoremap <C-K> <C-W>k
" nnoremap <C-H> <C-W>h
" nnoremap <C-L> <C-W>l
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
    " Mappings
    call minpac#add('tpope/vim-unimpaired')

    " External Documentation Lookup:
    call minpac#add('romainl/vim-devdocs')

    " FTPlugings:
    call minpac#add('vim-python/python-syntax')
    call minpac#add('Vimjas/vim-python-pep8-indent')
    call minpac#add('vim-scripts/bats.vim')
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
