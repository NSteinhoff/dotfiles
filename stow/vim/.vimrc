silent source $VIMRUNTIME/defaults.vim

colorscheme minimal

set mouse=a
set hidden
set wildmode=longest:full,full
set path=,,.
set shiftwidth=4
set softtabstop=-1
set expandtab
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+
set background=dark
set foldmethod=indent
set backspace=indent,eol,start
set modeline
set formatoptions+=j
set nowrap

set packpath=~/.vim,~/Development
packloadall

packadd! my-statusline
packadd! my-automations
packadd! my-commands
packadd! my-mappings
packadd! my-abbreviations
packadd! my-tags
packadd! my-repl

" --- Send to tmux
packadd! sendit

" --- Tpope's mappings
packadd! vim-unimpaired
" --- Bash
packadd! bats.vim
" --- Python
packadd! python-syntax
packadd! vim-python-pep8-indent
" --- Lisp/Scheme
packadd! vim-parinfer
packadd! vim-racket
