" --------------------------------- Options -----------------------------------
""" Colors
    colorscheme minimal
    set background=dark

""" Appearance
    set cmdheight=1
    set inccommand=split
    set laststatus=2
    set showmode
    set number
    set rulerformat=%25(%l,%c%V%M%=%P\ %y%)
    set scrolloff=5
    set sidescrolloff=3
    set showmatch
    set fillchars=eob:~
    set signcolumn=number

""" Behavior
    set noswapfile
    set updatetime=200
    set foldmethod=indent
    set foldlevelstart=99       " start with all folds opened
    set clipboard=unnamedplus   " always use clipboard
    set mouse=n                 " enable mouse in normal mode
    set autoread
    set hidden
    set ignorecase              " ignore case in searches ...
    set smartcase               " ... unless it includes capital letters
    set splitright              " open vertical splits on the right

""" Special characters
    set list
    set listchars=
    set listchars+=tab:>-
    set listchars+=trail:-
    set listchars+=extends:>
    set listchars+=precedes:<
    set listchars+=nbsp:+

""" Text formatting
    set shiftwidth=4
    set softtabstop=-1          " use the value of 'shiftwidth'
    set expandtab               " spaces instead of tabs

    set nowrap
    set linebreak
    set breakindent             " indent wrapped lines
    let &showbreak = '... '     " prepend wrapped lines with this
    set cindent

    set formatoptions=
    set formatoptions+=c        " wrap comments
    set formatoptions+=j        " remove commentstring when joining comment lines
    set formatoptions+=l        " don't wrap lines that were too long to begin with
    set formatoptions+=n        " recognize numbered lists
    set formatoptions+=q        " also format comments with 'gq'
    set formatoptions+=r        " continue comments when hitting <Enter>
    set nojoinspaces            " keep single spaces after sentences

""" Completions
    set wildmode=longest:full,full
    set completeopt=menuone,noinsert,noselect
    " set shortmess+=c

""" Path and files
    set path=,,.
    set wildignore+=**/target/**
    set wildignore+=**/node_modules/**


" --------------------------------- Plugins -----------------------------------
    if exists('g:vscode') | finish | endif
    packloadall     " load all default packages in 'start'

""" Personal
    packadd my-statusline
    packadd my-automations
    packadd my-commands
    packadd my-mappings
    packadd my-abbreviations
    packadd my-tags
    packadd my-completion

""" External
    " Finding / picking files
    " packadd! my-telescope            " fuzzy finder / picker
    packadd! my-dirvish              " file manager

    " Mappings and commands
    packadd! vim-unimpaired
    packadd! vim-eunuch
    packadd! vim-commentary

    " Help / Docs
    packadd! vim-devdocs                " open devdocs.io

    " Tmux repl
    packadd! my-tslime

    " Filetypes / Syntax / Indent
    packadd! editorconfig-vim           " ft settings based on local config

    " IDE Mode:
    packadd! my-lsp                     " Language Server client configuration
    " packadd! my-treesitter              " Semantic understanding of languages
