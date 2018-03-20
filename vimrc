"----- Basics -----
    set nocompatible                            " Enable Vim features (vi -> vim)
    set ttyfast                                 " Indicate a fast terminal connection
    set lazyredraw                              " Only redraw when necessary
    set ffs=unix,dos,mac                        " Unix as standard file type
    set encoding=utf8                           " Standard encoding
    set hidden                                  " Allow hidden buffers
    set showcmd                                 " Show commands in bottom line


"----- Filetypes -----
    filetype on                                 " Enable filetype detection
    filetype plugin on                          " Load filetype plugin files ('ftplugin.vim')
    filetype indent on                          " Load filetype indent files ('indent.vim')
    syntax enable                               " Enable syntax highlighting ('syntax.vim')


"----- UI -----
    set laststatus=2                            " Always show the statusbar
    set number                                  " Show line numbers
    set relativenumber                          " Show line numbers relative to current cursor position
    set numberwidth=4                           " Width of the number gutter
    set list                                    " Enable list mode showing 'listchars'
    set listchars=nbsp:¬,tab:»·,trail:·         " Configure which characters to show in list mode
    set foldcolumn=1                            " Show gutter that shows the foldlevel
    set scrolloff=7                             " Vertical offset from the cursor to the margins when scrolling
    set sidescrolloff=5                         " Horizontal offset from the cursor to the margins when scrolling

    " Filetype specific options
    augroup filetype_settings
        autocmd!
        autocmd FileType gitcommit set colorcolumn=70
        autocmd FileType markdown set colorcolumn=100
        autocmd FileType python,haskell,scala set colorcolumn=80
    augroup END


"----- Searching -----
    set incsearch                               " Incremental search
    set hlsearch                                " Highlight search results
    set wildmenu                                " Better command-line completion
    set wildmode=longest:full,full              " Default matching, but also start wildmenu
    set tags+=./tags;,.tags;                    " Search for .tags' files upwards
    set path+=**                                " Search downwards from current directory

    " Ignore certain files when searching
    set wildignore+=*.swp
    set wildignore+=*.zip
    set wildignore+=*.pyc
    set wildignore+=*__pycache__/*
    set wildignore+=*.egg-info/*
    set wildignore+=*.git/*
    set wildignore+=*db/*
    set wildignore+=*log/*
    set wildignore+=*docs/*
    set wildignore+=*target/*
    set wildignore+=*vendor/*
    set wildignore+=*node_modules/*
    set wildignore+=*.tox/*
    set wildignore+=*venv/*
    set wildignore+=*devenv/*
    set wildignore+=*runenv/*


"----- Folding -----
    set foldmethod=indent                       " Fold by indent
    set foldignore=                             " Fold everything
    set foldnestmax=8                           " Set the maximum number of folds


"----- Editing -----
    set backspace=2                             " Allow backspacing over 'indent,eol,start' => mode: 2

    " Indenting
    set autoindent                              " Automatically indent new lines
    " set smartindent                             " Be smart about indenting new lines

    " Wrapping
    set textwidth=0                             " Do not break long lines
    set nowrap                                  " Do not wrap long lines

    " Tabbing
    set tabstop=4                               " Number of spaces for each <Tab>
    set shiftwidth=4                            " Number of spaces to indent
    set softtabstop=4                           " Make <Tab>s feel like tabs while using spaces when inserting
    set shiftround                              " When indenting, always round to the nearest 'shiftwidth'
    set expandtab                               " Expand <Tab> into spaces

    " Autocompletion
    set complete-=t                             " Don't scan tags
    set complete-=i                             " Don't scan included files

"----- Statusline -----
    set statusline=[%{&ff}]%y\ %F%m%r%h%w%=%{gutentags#statusline()}%{fugitive#statusline()}[%l:%v\|%p%%]


"----- Browsing -----
    let g:netrw_liststyle=0                     " Set default view style [thin|long|wide|tree]
    let g:netrw_banner=0                        " Show banner no/yes [0|1]
    let g:netrw_altv=1                          " Open vertical splits on the right, not left
    let g:netrw_preview=1                       " Open previews in a vertical split, not horizontal
    let g:netrw_list_hide= '.*\.swp$,.*\.pyc'   " File patterns to hide from the list


"----- Custom Commands -----

    "--- General ---

    " Remove highlights of last search results
    nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
    " Make arrow keys do something useful -- resizing windows
    nnoremap <silent> <Left> :vertical resize -1<CR>
    nnoremap <silent> <Right> :vertical resize +1<CR>
    nnoremap <silent> <Up> :resize +1<CR>
    nnoremap <silent> <Down> :resize -1<CR>

    "--- Searching ---

    " Search for the name under the cursor in all files with the same extension
    nnoremap <leader>* *:vimgrep //j **/*%:e \| bo copen<CR>
    " Search for the last search pattern in all files with the same extension
    nnoremap <leader>/ :vimgrep //j **/*%:e \| bo copen<CR>


"----- ALE linting -----
    let g:ale_open_list = 1
    let g:ale_lint_delay = 1000
    let g:ale_linters = {
        \   'python': ['pylint', 'mypy'],
        \   'haskell': ['stack-ghc'],
        \}


"----- Gutentags -----
    let g:gutentags_ctags_tagfile='.tags'


"----- Snippets -----
    augroup filetype_snippets
        autocmd!
        au FileType python nnoremap <buffer> _bp oimport pdb; pdb.set_trace()<Esc>
        au FileType python nnoremap <buffer> _BP Oimport pdb; pdb.set_trace()<Esc>
    augroup END
