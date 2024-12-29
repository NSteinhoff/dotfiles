"{{{ Colors
set notermguicolors
colorscheme ludite
"}}}
"{{{ Appearance
set noshowcmd
set cmdheight=1
set inccommand=split
set showmode
set number
set smoothscroll
set scrolloff=1
set sidescrolloff=1
set showmatch
set signcolumn=number
set shortmess+=s
set concealcursor=n
set laststatus=2
set showtabline=2
set title
"}}}
"{{{ Behavior
set ttimeoutlen=25
set noswapfile
set updatetime=250
set foldenable
set foldmethod=indent
set foldlevelstart=99                           " start with all folds opened
set foldcolumn=0
set mouse=nv                                    " enable mouse in normal and visual mode
set mousemodel=extend
set ignorecase                                  " ignore case in searches ...
set smartcase                                   " ... unless it includes capital letters
set tagcase=match                               " Match case in :tag searches
set splitright                                  " open vertical splits on the right
set sessionoptions+=options                     " remember options and mappings
set isfname-==
set fileformats=unix                            " show <CR><NL>
set jumpoptions=stack
set undofile
"}}}
"{{{ Special characters
"set fillchars=eob:·
set list
set listchars=
set listchars+=tab:¦\ 
set listchars+=trail:…
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:␣
set listchars+=eol:¬
set listchars+=lead:\ 
" set listchars+=multispace:\ \ \ ·               " Add markers for every 4 spaces
"}}}
"{{{ Text formatting
set tabstop=8
set shiftwidth=4
set softtabstop=-1
set expandtab

set nowrap
set linebreak
set breakindent                                 " indent wrapped lines
set showbreak=└                                 " prepend wrapped lines with this
set smartindent

set formatoptions=
set formatoptions+=l                            " don't wrap lines that were too long to begin with
" sentences
set formatoptions+=p                            " don't wrap after . + single space
" set cpoptions+=J                                " require double space after sentences
" set joinspaces                                  " double spaces after sentences
" comments
set formatoptions+=c                            " wrap comments
set formatoptions+=j                            " remove commentstring when joining comment lines
set formatoptions+=q                            " also format comments with 'gq'
set formatoptions+=r                            " continue comments when hitting <Enter>
" lists
set formatoptions+=n                            " recognize numbered lists
" recognize * and - as list headers
set formatlistpat=^\\s*\\(\\d\\+[\\]:.)}\\t\ ]\\\|[*-][\\t\ ]\\)\\s*
"}}}
"{{{ Completions
set wildmode=longest:full,full
set wildoptions=pum
set completeopt=menuone,noinsert,noselect
set shortmess+=c
"}}}
"{{{ Path and files
set path=,,.
set wildignore+=*.dSym/
" set wildignore+=*/node_modules/*
"}}}
"{{{ Get help
set keywordprg=:Search\ ddg
"}}}

" vim: foldmethod=marker
