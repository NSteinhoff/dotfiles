" vim:foldmethod=marker
" source ~/dotfiles/hardcore.vim

"---------------------------------- Plugins -----------------------------------{{{
try
    source ~/.vim/plugins.vim
catch
    "No problem...
endtry
"}}}

"----------------------------------- Basics -----------------------------------{{{
if !has('nvim')
    unlet! skip_defaults_vim
    source $VIMRUNTIME/defaults.vim
    set autoread
endif

if has("gui_running")
    set guioptions-=m
    set guioptions-=T
    " set guioptions-=r
    " set guioptions-=L
    set guifont=Monospace\ 14
endif

set undodir=$HOME/.vim/undo                 " Persistent undo
set undofile

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

" Put backups and swapfiles in '.vim-tmp'
let s:tmpdir = $HOME . '/.vim-tmp'
if !isdirectory(s:tmpdir)
    echom 'Creating directory ' . s:tmpdir
    call mkdir(s:tmpdir)
endif
set backup
set swapfile
set backupdir=~/.vim-tmp
set directory=~/.vim-tmp
"}}}

"------------------------------------- UI -------------------------------------{{{
set laststatus=2                            " Always show the statusbar
set number                                  " Line numbers
set norelativenumber                        " Line numbers relative to current cursor position
set numberwidth=4                           " Width of the number gutter
set list                                    " Enable list mode showing 'listchars'
set listchars=nbsp:¬,tab:»·,trail:·         " Configure which characters to show in list mode
set fillchars=vert:\|,stl:\ ,stlnc:\ ,fold:\ 
set foldcolumn=0                            " Show gutter that shows the foldlevel
set scrolloff=3
set noshowmode
set nocursorcolumn
set nocursorline
"}}}

"--------------------------------- Searching ----------------------------------{{{
set hlsearch                                " Highlight search results
set wildmode=list:longest,full              " Default matching, but also start wildmenu
set tags+=./tags;,tags;
set tags+=./.tags;,.tags;
set tags+=./.git/tags;,.git/tags;
" set tags+=$HOME/lib/**/tags               " Use all tags under ~/libs
set path=,,                                 " Set base 'path'

" Ignore certain files when searching
set wildignore+=*.egg-info/*
set wildignore+=*.pyc
set wildignore+=*.swp
set wildignore+=*.tox/*
set wildignore+=*/out/*
set wildignore+=*.zip
set wildignore+=*__pycache__/*
set wildignore+=*db/*
set wildignore+=*devenv/*
set wildignore+=*docs/*
set wildignore+=*log/*
set wildignore+=*node_modules/*
set wildignore+=*runenv/*
set wildignore+=*target/*
set wildignore+=*vendor/*
set wildignore+=*venv/*
"}}}

"---------------------------- Documentation / Man --------------------------{{{
function! s:cheatSheet(topic)
    echo system('cht.sh ' . a:topic .'?Tq')
endfun
command! -nargs=+ Cht call s:cheatSheet(<q-args>)
if executable('cht.sh') && &keywordprg == 'man'
    set keywordprg=:Cht
endif
"}}}

"----------------------------------- Grep -------------------------------------{{{
" Use external 'grep' tool to search for patterns recursively
if executable('ag')
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
else
    set grepprg=grep\ -n\ -r\ --exclude='*.swp'\ --exclude='.tags'\ $*\ /dev/null
    set grepformat&
endif
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

"--------------------------------- Statusline ---------------------------------{{{
try
    set statusline=[%{mode()}]%y\ %l\|%c\ %w%q\ %=\ %f\ %P\ %m[%n]
    " set statusline=[%{mode()}]%y\ %l\|%c\ %w%q\ %{fugitive#statusline()}%=\ %f\ %P\ %m[%n]
catch
    " No problem...
    set statusline=[%{mode()}]%y\ %l\|%c\ %w%q\ %=\ %f\ %P\ %m[%n]
endtry
"}}}

"----------------------------- Filetype settings ------------------------------{{{
augroup filetype_settings
    autocmd!
    autocmd BufNewFile,BufRead *.boot setfiletype clojure
    autocmd BufNewFile,BufRead *.taskpaper setfiletype taskpaper
    autocmd BufNewFile,BufRead *.dvc setfiletype yaml
    autocmd BufNewFile,BufRead *.pyi setfiletype python
    autocmd BufNewFile,BufRead *.drl setfiletype scala
    autocmd BufNewFile,BufRead application.conf setfiletype hocon
    autocmd FileType python setlocal formatprg=yapf | compiler flake8
    autocmd FileType json setlocal formatprg=python\ -m\ json.tool
    autocmd FileType lisp,scala,markdown,Jenkinsfile setlocal shiftwidth=2 softtabstop=2
    autocmd FileType scala setlocal keywordprg=cht.sh\ scala
    autocmd FileType taskpaper setlocal noexpandtab
    autocmd FileType markdown let g:table_mode_corner='|'
    autocmd FileType rst let g:table_mode_corner='+' | let g:table_mode_header_fillchar='='
    autocmd FileType markdown setlocal suffixesadd+=.md
augroup END
"}}}

"------------------------------- Autoread -------------------------------------{{{
set updatetime=100                          " Fire CursorHold event after X milliseconds
augroup autoread_settings
    autocmd!
    autocmd CursorHold * silent! checktime  " Ingore errors when in command window
augroup END
"}}}

"------------------------------- Error Format ---------------------------------{{{
set errorformat+=%f\|%l\ col\ %c\|%m    " Allow reading error lists from buffers
"}}}

"-------------------------------- Colorscheme ---------------------------------{{{
try
    source ~/.vim/colorscheme.vim
catch
    "No problem...
endtry
"}}}

"------------------------------ Custom Commands -------------------------------{{{
try
    source ~/.vim/commands.vim
catch
    "No problem...
endtry
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
