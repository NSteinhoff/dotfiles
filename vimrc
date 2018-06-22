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

    " Put backups and swapfiles in '.vim-tmp'
    set backup
    set swapfile
    set backupdir=~/.vim-tmp
    set directory=~/.vim-tmp


"------------------------------------- UI -------------------------------------
    set laststatus=2                            " Always show the statusbar
    set nonumber                                " Line numbers
    set norelativenumber                        " Line numbers relative to current cursor position
    set numberwidth=4                           " Width of the number gutter
    set list                                    " Enable list mode showing 'listchars'
    set listchars=nbsp:¬,tab:»·,trail:·         " Configure which characters to show in list mode
    set foldcolumn=1                            " Show gutter that shows the foldlevel
    set scrolloff=3


"--------------------------------- Searching ----------------------------------
    set hlsearch                                " Highlight search results
    set wildmode=longest:full,full              " Default matching, but also start wildmenu
    set tags+=./tags;,.tags;                    " Search for .tags' files upwards
    " set path=.,,**                              " Search downwards from current directory

    " Ignore certain files when searching
    set wildignore+=*.egg-info/*
    set wildignore+=*.git/*
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
    " set smartindent                             " Be smart about indenting new lines

    " Wrapping
    set textwidth=0                             " Do not break long lines
    set nowrap                                  " Do not wrap long lines

    " Tabbing
    set tabstop=4                               " Number of spaces for each <Tab>
    set softtabstop=4                           " Make <Tab>s feel like tabs while using spaces when inserting
    set expandtab                               " Expand <Tab> into spaces

    " Autocompletion
    set complete-=t                             " Don't scan tags
    set complete-=i                             " Don't scan included files

"--------------------------------- Statusline ---------------------------------
    try
        set statusline=[%{&ff}]%y\ %F%m%r%h%w%=%{gutentags#statusline()}%{fugitive#statusline()}[%l:%v\|%p%%]
    catch
        " No problem...
    endtry


"----------------------------- Filetype settings ------------------------------
    augroup filetype_settings
        autocmd!
        autocmd BufNewFile,BufRead *.boot set ft=clojure
        autocmd BufNewFile,BufRead *.taskpaper set ft=taskpaper
        autocmd FileType gitcommit set colorcolumn=70
        autocmd FileType markdown set colorcolumn=100
        autocmd FileType python,haskell,scala,lisp,clojure set colorcolumn=80
        autocmd FileType python set formatprg=yapf
        autocmd FileType json set formatprg=python\ -m\ json.tool
        autocmd FileType lisp set shiftwidth=2 tabstop=2 softtabstop=2
        autocmd FileType scala set formatprg=scalafmt\ --config\ /Users/nikosteinhoff/.scalafmt.conf\ --stdin
        autocmd Filetype taskpaper set noexpandtab
    augroup END


"------------------------------- Error Format ---------------------------------
    set errorformat+=%f\|%l\ col\ %c\|%m    " Allow reading error lists from buffers


"-------------------------------- Colorscheme ---------------------------------
    try
        source ~/.vim/colorscheme.vim
    catch
        "No problem...
    endtry


"-------------------------------- Focus Mode ----------------------------------
    try
        source ~/.vim/focus.vim
    catch
        "No problem...
    endtry


"------------------------------ Custom Commands -------------------------------
    try
        source ~/.vim/commands.vim
    catch
        "No problem...
    endtry
