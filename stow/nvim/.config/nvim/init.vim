" --------------------------------- Options -----------------------------------
""" Colors
    colorscheme minimal
    set background=dark

""" Appearance
    set cmdheight=1
    set inccommand=split
    set laststatus=2
    set noshowmode
    set number
    set rulerformat=%25(%l,%c%V%M%=%P\ %y%)
    set scrolloff=5
    set sidescrolloff=3
    set showmatch
    set signcolumn=number       " reuse the number column for signs
    set noequalalways           " don't resize other windows
    set fillchars=eob:~

""" Behavior
    set updatetime=1000
    set foldmethod=indent
    set foldlevelstart=99       " start with all folds opened
    set clipboard=unnamedplus   " always use clipboard
    set mouse=n
    set autoread
    set hidden
    set ignorecase              " ignore case in searches ...
    set smartcase               " ... unless it includes capital letters

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
    set shortmess+=c

""" Path and files
    set path=,,.
    set wildignore+=*target*
    set wildignore+=*node_modules*


" --------------------------------- Plugins -----------------------------------
    packloadall     " load all default packages in 'start'

""" Personal
    packadd! my-statusline
    packadd! my-automations
    packadd! my-commands
    packadd! my-mappings
    packadd! my-abbreviations
    packadd! my-tags
    packadd! my-projects
    packadd! my-lsp
    packadd! my-pomodoro

""" External
    " Behavior
    packadd! editorconfig
    packadd! vim-unimpaired
    packadd! vim-eunuch

    " Filetypes
    packadd! python-syntax
    packadd! vim-jsx-pretty
    packadd! vim-python-pep8-indent

    " Customized
    " These are wrapper packages that load an external plugin along with the
    " customized setttings, commands, and mappings.
    packadd! their-telescope
    packadd! their-dirvish
