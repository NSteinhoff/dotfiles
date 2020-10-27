" --------------------------------- Options ----------------------------------- {{{
colorscheme minimal
set background=dark
" ---
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
set wildignore+=*/node_modules/*
set inccommand=split
" ---

"}}}

" --------------------------------- Plugins ----------------------------------- {{{
packloadall     " load all default packages in 'start'

" --- Personal
packadd! my-statusline
packadd! my-automations
packadd! my-commands
packadd! my-mappings
packadd! my-abbreviations
packadd! my-tags
packadd! my-lsp

" --- External
let g:loaded_netrwPlugin = 1    " don't load netrw
packadd vim-dirvish
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
"}}}

" vim:foldmethod=marker textwidth=0
