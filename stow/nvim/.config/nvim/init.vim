" --------------------------------- Options ----------------------------------- {{{

set runtimepath+=~/.vim/after
set packpath+=~/.vim

"--- UI{{{
set mouse=nv
set wildmode=longest:full,full
set background=dark
set laststatus=2
set number
set rulerformat=%25(%l,%c%V%M%=%P\ %y%)
set inccommand=split
set scrolloff=3
set sidescrolloff=3
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+
"}}}

"--- Editing{{{
set foldmethod=indent
set hidden
set path=,,.
set shiftwidth=4
set softtabstop=-1
set expandtab
set nowrap
set linebreak
set breakindent
let &showbreak = '... '
set showmatch
"}}}

"--- Searching{{{
set wildignore+=*/target/*
"}}}

"--- Colors{{{
try
    colorscheme minimal
    set background=dark
catch E185
    echo "Colorscheme not installed. Using the default colorscheme."
    colorscheme default
    set background=dark
endtry
"}}}

"--- Autoread{{{
set autoread
augroup autoread_settings
    autocmd!
    " check for file modification and trigger realoading
    autocmd CursorHold * silent! checktime
augroup END
"}}}

"--- Tags{{{

" Upward search from current file, then 'tags' in the working directory
" -> files dir (./xyz)
" -> upwards from file (./xyz;)
" -> cwd (xyz)
" -> upwards from cwd (xyz;)
" plain tags -> .git/tags
set tags =./tags
set tags+=./tags;
set tags+=tags
set tags+=tags;

" I've set up a git hook that get's installed for all repositories that
" creates tags files on git actions that change the index (commits,
" checkouts, merges, etc.). This file lives in the .git/ directory.
set tags+=./.git/tags
set tags+=./.git/tags;
set tags+=.git/tags
set tags+=.git/tags;

"}}}
"}}}

" --------------------------------- Plugins ----------------------------------- {{{
packadd theirs
packloadall

packadd! matchit

" Open packages with :PackEdit **/{pack}.vim
packadd! my-statusline
packadd! my-automations
packadd! my-commands
packadd! my-mappings
packadd! my-abbreviations
" packadd! my-pomodoro
" packadd! my-repl
" packadd! my-differ

" set runtimepath+=~/Development/vim-igitt/ | runtime! plugin/igitt.vim

" Dev packages under ~/Development/pack/*/opt/
set packpath+=~/Development

packadd trepl
let g:trepl_always_current_session = 1
let g:trepl_always_current_window = 1

"}}}

" vim:foldmethod=marker textwidth=0
