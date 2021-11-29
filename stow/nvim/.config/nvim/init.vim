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
        set shortmess+=s

""" Behavior
        set ttimeoutlen=25
        set noswapfile
        set updatetime=250
        set foldenable
        set foldmethod=indent
        set foldlevelstart=99       " start with all folds opened
        set foldcolumn=0
        set mouse=nv                " enable mouse in normal and visual mode
        set autoread
        set hidden
        set ignorecase              " ignore case in searches ...
        set smartcase               " ... unless it includes capital letters
        set tagcase=match           " ... but match case in :tag searches
        set splitright              " open vertical splits on the right
        set sessionoptions+=options " remember options and mappings

""" Special characters
        set list
        set listchars=
        set listchars+=tab:›┄
        set listchars+=trail:…
        set listchars+=extends:»
        set listchars+=precedes:«
        set listchars+=nbsp:␣
        " set listchars+=eol:¬
        set listchars+=lead:\ 
        set listchars+=multispace:\ •

""" Text formatting
        set tabstop=8
        set shiftwidth=4
        set softtabstop=-1
        set smarttab
        set expandtab

        set nowrap
        set linebreak
        set breakindent             " indent wrapped lines
        set showbreak=└             " prepend wrapped lines with this
        set smartindent

        set formatoptions=
        set formatoptions+=l        " don't wrap lines that were too long to begin with
        " sentences
        set formatoptions+=p        " don't wrap after . + single space
        set cpoptions+=J            " require double space after sentences
        set joinspaces              " double spaces after sentences
        " comments
        set formatoptions+=c        " wrap comments
        set formatoptions+=j        " remove commentstring when joining comment lines
        set formatoptions+=q        " also format comments with 'gq'
        set formatoptions+=r        " continue comments when hitting <Enter>
        " lists
        set formatoptions+=n        " recognize numbered lists
                                    " recognize * and - as list headers
        set formatlistpat=^\\s*\\(\\d\\+[\\]:.)}\\t\ ]\\\|[*-][\\t\ ]\\)\\s*


""" Completions
        set wildmode=longest:full,full
        " set completeopt=menuone
        set completeopt=menuone,noinsert,noselect
        set shortmess+=c

""" Path and files
        set path=,,.
        set wildignore+=**/target/**
        set wildignore+=**/node_modules/**

""" Diffing
        " Speed up diff syntax highlighting by disabling localization
        let g:diff_translations = 0

""" Get help
        set keywordprg=:DuckDuckGo

" --------------------------------- Plugins -----------------------------------
        " Stop here in case we are running in VSCode
        if exists('g:vscode') | finish | endif
        packloadall     " load all default packages in 'start'

""" Personal
        packadd my-abbreviations
        packadd my-automations
        packadd my-commands
        packadd my-compiler
        packadd my-completions
        packadd my-mappings
        packadd my-marks
        packadd my-lualib
        packadd my-quickfix
        packadd my-statusline
        packadd my-tabline
        packadd my-tags
        " packadd my-zettelkasten

""" External
        " Finding / picking files
        packadd! my-dirvish                 " Minimalist file browser

        " Lua documentation
        packadd! nvim-luaref                " Lua documentation as vim help files

        " Mappings and commands
        packadd! vim-unimpaired             " Convenience mappings
        packadd! vim-eunuch                 " Shell commmands
        packadd! vim-commentary             " Comment out stuff

        " Filetypes / Syntax / Indent
        packadd! editorconfig-vim           " File type settings based on local config

        " IDE Mode
        packadd! my-lsp                     " Language Server client configuration
        packadd! my-treesitter              " Language aware highlighting

        " Format quickfix
        " packadd! my-pqf

""" Development
        set packpath+=~/dev
