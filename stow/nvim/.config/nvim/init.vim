" --------------------------------- Options ----------------------------------- {{{
set runtimepath+=~/.vim/after
set packpath=~/.vim,~/Development
"---
set mouse=nv
set laststatus=2
set number
set rulerformat=%25(%l,%c%V%M%=%P\ %y%)
set scrolloff=3
set sidescrolloff=3
set showmatch
set foldmethod=indent
"---
set autoread
set hidden
set path=,,.
"---
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+
"---
set shiftwidth=4
set softtabstop=-1
set expandtab
set nowrap
set linebreak
set breakindent
let &showbreak = '... '
" ---
set wildmode=longest:full,full
set wildignore+=*/target/*
set inccommand=split
" ---
colorscheme minimal
set background=dark

"}}}

" --------------------------------- Plugins ----------------------------------- {{{
" Dev packages under ~/Development/pack/*/opt/
set packpath+=~/Development
packloadall

packadd! matchit

" Open packages with :PackEdit **/{pack}.vim
packadd! my-statusline
packadd! my-automations
packadd! my-commands
packadd! my-mappings
packadd! my-abbreviations
packadd! my-tags
" packadd! my-pomodoro
" packadd! my-repl
" packadd! my-differ

packadd! vim-unimpaired
packadd! bats.vim
packadd! python-syntax
packadd! vim-parinfer
packadd! vim-python-pep8-indent
packadd! vim-racket

packadd! sendit
let g:sendit_always_current_session = 1
let g:sendit_always_current_window = 1

"}}}

" vim:foldmethod=marker textwidth=0
