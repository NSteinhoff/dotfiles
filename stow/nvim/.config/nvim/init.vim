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
    set hlsearch

""" Behavior
    set noswapfile
    set updatetime=200
    set foldenable
    set foldmethod=indent
    set foldlevelstart=99       " start with all folds opened
    set foldcolumn=0
    set clipboard=unnamedplus   " always use clipboard
    set mouse=nv                " enable mouse in normal and visual mode
    set autoread
    set hidden
    set ignorecase              " ignore case in searches ...
    set smartcase               " ... unless it includes capital letters
    set tagcase=match           " ... but match case in :tag searches
    set splitright              " open vertical splits on the right
    set sessionoptions+=options " save global mappings and options

""" Special characters
    set list
    set listchars=
    set listchars+=tab:>-
    set listchars+=trail:-
    set listchars+=extends:>
    set listchars+=precedes:<
    set listchars+=nbsp:+

""" Text formatting
    set smarttab
    set tabstop=4
    set shiftwidth=4
    set softtabstop=-1          " use the value of 'shiftwidth'
    set expandtab               " spaces instead of tabs

    set nowrap
    set linebreak
    set breakindent             " indent wrapped lines
    let &showbreak = '... '     " prepend wrapped lines with this
    set smartindent

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
    set completeopt=menuone
    " set completeopt=menuone,noinsert,noselect
    " set shortmess+=c

""" Path and files
    set path=,,.
    set wildignore+=**/target/**
    set wildignore+=**/node_modules/**

""" Highlight todo items
    aug syn-todo
        autocmd!
        autocmd BufEnter * syn keyword todo    todo Todo TODO todo: Todo: TODO:
    aug END


" --------------------------------- Plugins -----------------------------------
    if exists('g:vscode') | finish | endif
    packloadall     " load all default packages in 'start'

""" Personal
    packadd my-abbreviations
    packadd my-automations
    packadd my-completions
    packadd my-statusline
    packadd my-tags
    packadd my-commands
    packadd my-mappings

    " Note-taking
    packadd my-zettelkasten

""" External
    " Finding / picking files
    packadd! my-dirvish                 " file manager
    packadd! my-numb                    " peek at lines :{num}

    " Mappings and commands
    packadd! vim-unimpaired
    packadd! vim-eunuch
    packadd! vim-commentary

    " Filetypes / Syntax / Indent
    packadd! editorconfig-vim           " ft settings based on local config

    " IDE Mode
    packadd! my-lsp                     " Language Server client configuration
    packadd! my-treesitter              " Semantic understanding of languages

""" Development
    set packpath+=~/dev
