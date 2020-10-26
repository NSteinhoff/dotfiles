" --------------------------------- Options ----------------------------------- {{{
set runtimepath+=~/.vim/after
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
" Dev packages under ~/dev/pack/*/opt/
set packpath=~/.vim,~/dev
packloadall     " load all default packages in 'start'

" --- Personal packages
packadd! my-statusline
packadd! my-automations
packadd! my-commands
packadd! my-mappings
packadd! my-abbreviations
packadd! my-tags
packadd! my-lsp

" Create the root directory for external packages
let s:packroot = expand('~/dev').'/pack/external/opt'
if !isdirectory(s:packroot)
    echo "Creating external package root directory '".s:packroot."'"
    call mkdir(s:packroot, 'p')
endif

" --- Editorconfig
packadd! editorconfig-vim

" --- Tpope's mappings
packadd! vim-unimpaired

" --- Python
packadd! python-syntax
packadd! vim-python-pep8-indent

" --- JSX / TSX
packadd! vim-jsx-pretty
"}}}

" vim:foldmethod=marker textwidth=0
