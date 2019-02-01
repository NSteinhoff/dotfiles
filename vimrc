"---------------------------------- Plugins -----------------------------------
    try
        source ~/.vim/plugins.vim
    catch
        "No problem...
    endtry


"----------------------------------- Basics -----------------------------------
    if !has('nvim')
        unlet! skip_defaults_vim
        source $VIMRUNTIME/defaults.vim
        set autoread
        set ttyfast                                 " Indicate a fast terminal connection
    endif
    set undodir=$HOME/.vim/undo
    set undofile
    filetype plugin indent on
    set lazyredraw                              " Only redraw when necessary
    set ffs=unix,dos,mac                        " Unix as standard file type
    set encoding=utf8                           " Standard encoding
    set hidden                                  " Allow hidden buffers
    set clipboard=unnamed                       " Yank into '*' register
    set mouse=                                  " Mouse? PFUII!!

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


"------------------------------------- UI -------------------------------------
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


"--------------------------------- Searching ----------------------------------
    set hlsearch                                " Highlight search results
    set wildmode=longest:full,full              " Default matching, but also start wildmenu
    set tags+=./tags;,tags;
    set tags+=./.tags;,.tags;
    set tags+=./.git/tags;,.git/tags;
    set path-=/usr/include
    " set path=,,                                 " Search the current directory
    " set path+=.                                 " Search relative to the current file
    " set path+=**                                " Search downwards from current directory

    " Ignore certain files when searching
    set wildignore+=*.egg-info/*
    set wildignore+=*.pyc
    set wildignore+=*.swp
    set wildignore+=*.tox/*
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


"----------------------------------- Grep -------------------------------------
    " Use external 'grep' tool to search for patterns recursively
    if executable('ag')
        set grepprg=ag\ --vimgrep\ $*
        set grepformat=%f:%l:%c:%m
    else
        set grepprg=grep\ -n\ -r\ --exclude='*.swp'\ --exclude='.tags'\ $*\ /dev/null
        set grepformat&
    endif

"---------------------------------- Folding -----------------------------------
    set foldmethod=indent                       " Fold by indent
    set foldignore=                             " Fold everything
    set foldnestmax=8                           " Set the maximum number of folds

"---------------------------------- Editing -----------------------------------
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

"--------------------------------- Statusline ---------------------------------
    try
        set statusline=[%{mode()}]\ %l\|%c\ %=\ %f\ %P\ %m
        " set statusline=[%{&ff}]%y\ %F%m%r%h%w%=%{fugitive#statusline()}[%l:%v\|%p%%]
    catch
        " No problem...
        set statusline=%l\|%c%=%f\ %P\ %m
    endtry

"----------------------------- Filetype settings ------------------------------
    augroup filetype_settings
        autocmd!
        autocmd BufNewFile,BufRead *.boot set ft=clojure
        autocmd BufNewFile,BufRead *.taskpaper set ft=taskpaper
        " autocmd FileType vim,python,haskell,scala,lisp,clojure set cc=80
        autocmd FileType python set formatprg=yapf
        autocmd FileType json set formatprg=python\ -m\ json.tool
        autocmd FileType lisp,scala,markdown,Jenkinsfile set shiftwidth=2 softtabstop=2
        autocmd FileType taskpaper set noexpandtab
        autocmd FileType markdown let g:table_mode_corner='|'
        autocmd FileType rst let g:table_mode_corner='+' | let g:table_mode_header_fillchar='='
        autocmd FileType markdown set suffixesadd+=.md
        " autocmd FileType gitcommit let b:m2=matchadd('ErrorMsg', '\%>70v.\+', -1)
        " autocmd FileType markdown let b:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
        " autocmd FileType let b:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
    augroup END

"------------------------------- Autoread -------------------------------------
    set updatetime=100                          " Fire CursorHold event after X milliseconds
    augroup autoread_settings
        autocmd!
        autocmd CursorHold * silent! checktime  " Ingore errors when in command window
    augroup END

"------------------------------- Error Format ---------------------------------
    set errorformat+=%f\|%l\ col\ %c\|%m    " Allow reading error lists from buffers


"-------------------------------- Colorscheme ---------------------------------
    try
        source ~/.vim/colorscheme.vim
    catch
        "No problem...
    endtry


"------------------------------ Custom Commands -------------------------------
    try
        source ~/.vim/commands.vim
    catch
        "No problem...
    endtry
