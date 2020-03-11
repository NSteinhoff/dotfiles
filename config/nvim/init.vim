source ~/.vimrc

augroup settings
    autocmd!
    " Source this file on write
    autocmd! BufWritePost .vimrc,vimrc,init.vim source % "
augroup END


" --------------------------------- Editing -----------------------------------{{{
set inccommand=split

"}}}


" -------------------------------- Searching ----------------------------------{{{
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
elseif executable('ag')
    set grepprg=ag\ --vimgrep\ --smart-case
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
    autocmd FileType scala,rust,python set tagfunc=myfuncs#fttags  " FileType specific tags
augroup END


"}}}


" ---------------------------------- Commands --------------------------------{{{
" Align text
" Using 'sed' and 'column' external tools
command! -range Align <line1>,<line2>!sed 's/\s\+/~/g' | column -s'~' -t
command! -nargs=1 -range AlignOn <line1>,<line2>!sed 's/\s\+<args>/ ~<args>/g' | column -s'~' -t

" Headers
command! -nargs=? Center call myfuncs#center(<q-args>)
command! -nargs=? Header call myfuncs#header(<q-args>)

command! WhichCompiler echo compiler#which()
command! -nargs=1 -complete=compiler CompileWith call compiler#with(<f-args>)
command! DescribeCompiler call compiler#describe()
"}}}


" --------------------------------- Mappings ---------------------------------{{{

" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'

" Window resizing with the arrow keys
map <right> 10<c-w>>   " increase width
map <left> 10<c-w><    " decrease width
map <up> 10<c-w>+      " increase height
map <down> 10<c-w>-    " decrease height


" Fuzzy file finding within the working directory
nnoremap <leader>e :edit **/*
nnoremap <leader>s :vsplit **/*
nnoremap <leader>t :tabedit **/*

" Quick buffer switching
set wildcharm=<C-Z>
nnoremap <leader>b :buffer <C-Z>
nnoremap <leader>v :vert sbuffer <C-Z>

" Clear search highlights
if maparg('<ESC>', 'n') ==# ''
    nnoremap <silent> <ESC> :nohlsearch<CR>
endif

" <F5> is always set to make the project
nnoremap <F5> :make!<cr>
nnoremap <leader><F5> :DescribeCompiler<cr>
nnoremap <leader>? :DescribeCompiler<cr>

" [ and ] mappings to navigate lists
nnoremap [a :previous<cr>
nnoremap ]a :next<cr>

nnoremap [b :bprevious<cr>
nnoremap ]b :bnext<cr>

nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>

nnoremap [l :lprevious<cr>
nnoremap ]l :lnext<cr>

nnoremap [t :tprevious<cr>
nnoremap ]t :tnext<cr>

nnoremap [p :ptprevious<cr>
nnoremap ]p :ptnext<cr>



" ---------------------------------- Netrw ------------------------------------{{{
" Hide files that are ignored by git
let g:netrw_list_hide= netrw_gitignore#Hide()
let g:netrw_preview = 1
let g:netrw_altv = 1
let g:netrw_alto = 0
"}}}


" --------------------------------- Plugins ----------------------------------{{{

" Personal plugins
packadd! abbreviations
packadd! providers
packadd! statusline
packadd! pomodoro
packadd! differ

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

    " File Exlorer:
    " call minpac#add('preservim/nerdtree')

    " REPL:
    " Tmux based REPL integration using 'tslime'
    call minpac#add('jgdavey/tslime.vim')

    " Clojure:
    " nRepl integration
    call minpac#add('bhurlow/vim-parinfer')
    call minpac#add('tpope/vim-fireplace')

    " FTPlugings:
    " call minpac#add('sheerun/vim-polyglot')
    call minpac#add('vim-python/python-syntax')
    call minpac#add('Vimjas/vim-python-pep8-indent')

    " Language Server:
    call minpac#add('neovim/nvim-lsp')

    " Devdocs as helpprg:
    call minpac#add('romainl/vim-devdocs')
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

" tslime
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

"}}}




" vim:foldmethod=marker textwidth=0
