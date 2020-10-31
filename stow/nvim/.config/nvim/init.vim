" --------------------------------- Options ----------------------------------- {{{
colorscheme minimal
set background=dark
" ---
set mouse=nv
set laststatus=2
set number
set signcolumn=number
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
set wildignore+=*target*
set wildignore+=*node_modules*
set completeopt=menuone,noinsert,noselect
set shortmess+=c
" ---
set inccommand=split

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
packadd! my-projects
packadd! my-lsp
packadd! my-telescope

" --- External
" Behavior
packadd! editorconfig
packadd! vim-unimpaired
packadd! vim-eunuch
packadd! vim-dirvish
packadd! vim-dirvish-git

" Filetypes
packadd! python-syntax
packadd! vim-jsx-pretty
packadd! vim-python-pep8-indent

" --- Configuration
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
augroup dirvish_mappings
    autocmd!
    autocmd Filetype dirvish nmap <SPACE> <CR>
augroup END
"}}}

" ---------------------------------- Paths ------------------------------------ {{{
let g:cwd_paths = {
            \ fnamemodify($HOME, ':t'): '~/dev/dotfiles/,~/dev/dotfiles/stow/',
            \ 's2': '*/src/**,*/packages/*/src/**',
            \}

let g:rcfile_paths = {
            \ 'package.json': 'src/**,packages/*/src/**',
            \ 'setup.py': 'src,test',
            \}
"  }}}

" vim:foldmethod=marker textwidth=0
