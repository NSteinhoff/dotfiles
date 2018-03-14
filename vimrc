"----- Basics -----
    set nocompatible                            " Enable Vim features (vi -> vim)
    set ttyfast                                 " Indicate a fast terminal connection
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
    set laststatus=2
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


"----- Colorscheme -----
    set background=dark
    colorscheme default


"----- Searching -----
    set incsearch                               " Incremental search
    set hlsearch                                " Highlight search results


"----- Folding -----
    set foldmethod=indent                       " Fold by indent
    set foldignore=                             " Fold everything
    set foldnestmax=8                           " Set the maximum number of folds


"----- Editing -----
    set backspace=2                             " Allow backspacing over 'indent,eol,start' => mode: 2

    " Indenting
    set autoindent                              " Automatically indent new lines
    set smartindent                             " Be smart about indenting new lines

    " Wrapping
    set textwidth=0                             " Do not break long lines
    set nowrap                                  " Do not wrap long lines

    " Tabbing
    set tabstop=4                               " Number of spaces for each <Tab>
    set shiftwidth=4                            " Number of spaces to indent
    set softtabstop=4                           " Make <Tab>s feel like tabs while using spaces when inserting
    set shiftround                              " When indenting, always round to the nearest 'shiftwidth'
    set expandtab                               " Expand <Tab> into spaces


"----- Statusline -----
    set statusline=[%{&ff}]%y\ %F%m%r%h%w%=[%l:%v\|%p%%]


"----- Browsing -----
    let g:netrw_liststyle=0                     " Set default view style [thin|long|wide|tree]
    let g:netrw_banner=0                        " Show banner yes/no [0|1]
    let g:netrw_altv=1                          " Open vertical splits on the right, not left
    let g:netrw_preview=1                       " Open previews in a vertical split, not horizontal
    let g:netrw_list_hide= '.*\.swp$,.*\.pyc'   " File patterns to hide from the list


"----- Custom Commands -----
    nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
