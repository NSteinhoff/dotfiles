"----------------------------------- Basics -----------------------------------{{{
source $VIMRUNTIME/defaults.vim
set nocompatible

if has("gui_running")
    set guioptions-=m
    set guioptions-=T
    set guifont=Monospace\ 14
    colorscheme desert
endif

filetype plugin indent on                   " Filetype detection and indentation
syntax on                                   " Syntax highlighting
let mapleader = '\'
set ttyfast                                 " Indicate a fast terminal connection
set lazyredraw                              " Only redraw when necessary
set ffs=unix,dos,mac                        " Unix as standard file type
set encoding=utf8                           " Standard encoding
set hidden                                  " Allow hidden buffers
set clipboard=unnamed                       " Yank into '*' register
set mouse=                                  " Mouse? PFUII!!
set modeline                                " Respect modeline options
set wildmenu                                " Enable the wildmenu for tab completion
set wildmode=longest:full,full
"}}}

"------------------------------------- UI -------------------------------------{{{
set background=dark
set laststatus=2                            " Always show the statusbar
set number                                  " Line numbers
set norelativenumber                        " Line numbers relative to current cursor position
set numberwidth=4                           " Width of the number gutter
set list                                    " Enable list mode showing 'listchars'
" Configure which characters to show in list mode
set listchars=tab:>-,trail:-,nbsp:+
set listchars+=extends:>,precedes:<
set foldcolumn=0                            " Show gutter that shows the foldlevel
set scrolloff=3
set noshowmode
set nocursorcolumn
set nocursorline
"}}}

"---------------------------------- Folding -----------------------------------{{{
set foldmethod=indent                       " Fold by indent
set foldignore=                             " Fold everything
set foldnestmax=8                           " Set the maximum number of folds
"}}}

"---------------------------------- Editing -----------------------------------{{{
" Indenting
set shiftwidth=4                            " Number of spaces to indent
set shiftround                              " When indenting, always round to the nearest 'shiftwidth'
set autoindent                              " Automatically indent new lines
set smartindent                             " Be smart about indenting new lines

" Wrapping
set textwidth=0                             " Do not break long lines
set nowrap                                  " Do not wrap long lines

" Tabbing
set tabstop=8                               " Number of spaces for each <Tab>
set softtabstop=-1                          " Make <Tab>s feel like tabs while using spaces when inserting
set expandtab                               " Expand <Tab> into spaces
set smarttab                                " Be smart about inserting and deleting tabs

" Autocompletion
set complete-=t                             " Don't scan tags
set complete-=i                             " Don't scan included files
"}}}

"---------------------------------- Diff -----------------------------------{{{
set diffopt+=iwhite
set diffopt+=hiddenoff
"}}}

"------------------------------- Autoread -------------------------------------{{{
set updatetime=100                          " Fire CursorHold event after X milliseconds
augroup autoread_settings
    autocmd!
    autocmd CursorHold * silent! checktime  " Ingore errors when in command window
augroup END
"}}}

"------------------------------- Abbreviations --------------------------------{{{
abbrev &oops; (」ﾟヘﾟ)」
abbrev &woo; ＼(◎o◎)／
abbrev &facepalm; (>ლ)
abbrev &flex; ᕙ(⇀‸↼‶)ᕗ
abbrev &happy; ＼(^o^)／
abbrev &rage; (╯°□°）╯︵ ┻━┻
abbrev &scared; ヽ(ﾟДﾟ)ﾉ
abbrev &shrug; ¯\_(ツ)_/¯
abbrev &strut; ᕕ( ᐛ )ᕗ
abbrev &zoidberg; (V) (°,,,,°) (V)
abbrev &huh; (⊙.☉)7
abbrev &confused; ¯\_(⊙︿⊙)_/¯
abbrev &dunno; ¯\(°_o)/¯
abbrev &sad; (ಥ_ಥ)
abbrev &cry; (ಥ﹏ಥ)
abbrev &wat; (ÒДÓױ)
abbrev &smile; ʘ‿ʘ
abbrev &brb; Be right back.
"}}}

" vim:foldmethod=marker
