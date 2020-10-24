silent source $VIMRUNTIME/defaults.vim

colorscheme minimal

set mouse=a
set hidden
set wildmenu
set wildmode=longest:full,full
set wildignore+=node_modules/**
set wildignore+=**/node_modules/**
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
set hlsearch
set number

" Tweak 'grep' options
" Default: grep -n $* /dev/null
"
" * -I
"       ignore binary files
" * --exclude='*/node_modules/*'
"       ignore node_modules folder
set grepprg=grep\ -I\ -n\ --exclude='*/node_modules/*'\ $*\ /dev/null


"---------------------------------------------------------------------------- "
"                                  Packages                                   "
"---------------------------------------------------------------------------- "
set packpath=~/.vim
packloadall

packadd! my-statusline
packadd! my-automations
packadd! my-commands
packadd! my-mappings
packadd! my-abbreviations
packadd! my-tags
packadd! my-repl


" ---------------------------- External Packages ------------------------------
let s:external_packpath = "~/dev"
execute 'set packpath+='.s:external_packpath

" Create the root directory for external packages
let s:packroot = expand(s:external_packpath).'/pack/external/opt'
if !isdirectory(s:packroot)
    echo "Creating external package root directory '".s:packroot."'"
    call mkdir(s:packroot, 'p')
endif

" --- Editorconfig
packadd! editorconfig-vim

" --- Send to tmux
packadd! sendit

" --- Tpope's mappings
packadd! vim-unimpaired

" --- Bash
packadd! bats.vim

" --- Python
packadd! python-syntax
packadd! vim-python-pep8-indent

" --- JSX / TSX
packadd! vim-jsx-pretty

" --- Lisp/Scheme
packadd! vim-parinfer
packadd! vim-racket

" --- LSP
packadd! vim-lsp
packadd! vim-lsp-settings
packadd! my-lsp
