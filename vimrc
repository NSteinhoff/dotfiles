""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Filename: .vimrc
  " Sections:
  "
  "   01. General ................. General Vim behavior
  "
  "   02. Events .................. General autocmd events
  "
  "   03. Theme/Colors ............ Colors, fonts, etc.
  "
  "   04. Vim UI .................. User interface behavior
  "
  "   05. Text Formatting/Layout .. Text, tab, indentation related
  "
  "   06. Custom Commands ......... Any custom command aliases
  "
  "   07. Plugin Configuration .... Configurations of Vundle Plugins
  "
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 01. Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set nocompatible                    " get rid of Vi compatibility mode. SET FIRST!

    " Managing Plugins
    filetype off                        " required

    " Vundle
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'gmarik/Vundle.vim'

    " Bundles to install go here:
    """""""""""""""""""""""""""""""""""""
    """"" UI """""
        " Colorschemes
        Plugin 'chriskempson/base16-vim'
        Plugin 'tyrannicaltoucan/vim-quantum'
        Plugin 'arcticicestudio/nord-vim'

        " Statusline                           " Nice status line
        " Plugin 'vim-airline/vim-airline'
        " Plugin 'vim-airline/vim-airline-themes'

        Plugin 'itchyny/lightline.vim'

        " Rainbow Parantheses
        Plugin 'rainbow_parentheses.vim'

        " Fugitive
        Plugin 'fugitive.vim'
        Plugin 'airblade/vim-gitgutter'

        " Indent Guides
        Plugin 'nathanaelkane/vim-indent-guides'

    """"" General Functionality """""
        " csv.vim
        Plugin 'csv.vim'                    " Added functionality for reading
                                            " and editing .csv files
        " Text alignment
        Plugin 'Tabular'

        " Syntax Checking
        " Plugin 'https://github.com/scrooloose/syntastic.git'
        Plugin 'w0rp/ale'

        " Automatically update tags
        Plugin 'craigemery/vim-autotag'

        " Autoformat
        Plugin 'Chiel92/vim-autoformat'

    """""" Language Specific """"""
    """ Markdown """
        Plugin 'gabrielelana/vim-markdown'

    """ Python """
        Plugin 'hynek/vim-python-pep8-indent'
        Plugin 'https://github.com/hdima/python-syntax'

    """ Haskell """
        Plugin 'haskell.vim'

    """ Scala """
        Plugin 'derekwyatt/vim-scala'
        " Plugin 'ensime/ensime-vim'

    """""""""""""""""""""""""""""""""""""
    call vundle#end()                   " required

    runtime! ftplugin/man.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set ffs=unix,dos,mac        " Unix as standard file type
    set encoding=utf8           " Standard encoding
    filetype plugin indent on   " filetype detection[ON] plugin[ON] indent[ON]
    set hidden                  " Allow hidden buffers by default
    set tags=.tags;/
    set path+=$PWD/**
    set noignorecase
    set nospell


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " if &term == "screen"
    "   set t_Co=256
    " endif
    set background=dark
    set termguicolors
    colorscheme nord
    " let g:airlinetheme='nord'

    " if &diff
    "     colorscheme base16-default-dark
    " else
    "     colorscheme base16-default-dark
    " endif


    syntax enable                       " enable syntax highlighting

    augroup filetype_settings
        autocmd!
        autocmd FileType python,haskell,scala set colorcolumn=80
        autocmd FileType markdown set colorcolumn=100
        autocmd FileType gitcommit set colorcolumn=70
    augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set lazyredraw              " only redraw if necessary
    set number                  " show line numbers
    set relativenumber          " show relative line numbers
    set numberwidth=4           " make the number gutter 4 characters wide
    set laststatus=2            " last window always has a statusline
    set incsearch               " Highlight as you type your search.
    set ruler                   " Always show info along bottom.
    set showmatch               " Show matching braces
    set visualbell              " Visual feedback
    set scrolloff=7             " Vertical offset
    set sidescrolloff=5         " Horizontal offset
    set ttyfast                 " Faster
    set showcmd                 " Show partial commands
    set hlsearch                " highlight search terms in text
    hi IncSearch term=underline cterm=underline gui=underline
    set foldmethod=indent       " how to determine folds
    set foldcolumn=4            " Show indicator column for the first 4 folds in a sidebar
    set foldnestmax=8           " limit nested folds
    set foldignore=             " Set this to nothing to also fold python comments

    " Show funny characters
    set list
    set listchars=nbsp:¬,tab:»·,trail:·

    " Wildmenu
    set wildmenu                                        " command line completion
    set wildmode=longest:full,full
    set wildignore=*.swp,*.zip,*.pyc
    set wildignore+=**/.git/**,**/db/**,**/log/**,**/docs/**
    set wildignore+=**/target/**,**/vendor/**,**/node_modules/**
    set wildignore+=**/devenv/**,**/venv/**,**/env/**,**/runenv/**

    " Autocompletion
    set complete-=t             " don't scan tags
    set complete-=i             " don't scan files


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Text Formattingk/Layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set autoindent              " auto-indent
    set tabstop=4               " tab spacing
    set softtabstop=4           " unify
    set shiftwidth=4            " indent/outdent by 4 columns
    set shiftround              " always indent/outdent to the nearest tabstop
    set expandtab               " use spaces instead of tabs
    set cindent                 " automatically insert one extra level of
                                " indentation
    set nowrap                  " don't wrap text
    set backspace=2


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Custom Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "
    " Disable arrow keys
    noremap <Up> <NOP>
    noremap <Down> <NOP>
    noremap <Left> <NOP>
    noremap <Right> <NOP>
    "
    " activate/deactivate paste mode
    set pastetoggle=<F2>
    "
    " faster exiting insert mode without having to leave the homerow
    " inoremap jk <esc>
    "
    " easier switching between vim splits
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
    "
    " easier resizing of vim splits
    nnoremap - <C-w><
    nnoremap = <C-w>>
    nnoremap _ <C-w>-
    nnoremap + <C-w>+
    "
    " resync folding
    nnoremap <Leader>z :syn sync fromstart<cr>
    "
    " open/close folds
    " nnoremap <Space> za

    " remove search highlights
    nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
    "
    " create opening and closing brackets and put cursor inside:
    inoremap {{ {}<Left>
    inoremap {{<CR> {<CR>}<esc>kA<CR>
    inoremap [[ []<Left>
    inoremap [[<CR> [<CR>]<esc>kA<CR>
    inoremap (( ()<Left>
    inoremap ((<CR> (<CR>)<esc>kA<CR>
    inoremap """ """"""<Left><Left><Left>
    inoremap """<CR> """<CR>"""<esc>kA

    " autocommands:
    augroup write_events
        autocmd!
        " Source vimrc on write
        autocmd BufWritePost *vimrc :so %
        autocmd BufWritePost *.hs :!ghc --make %:p
    augroup END

    augroup script_execution
        autocmd!
        " execute the current file with python
        autocmd FileType python nnoremap <Leader>R
                    \ :w<cr>
                    \ :!echo Running python script: %:p &&
                    \ python %:p<cr>
        autocmd FileType haskell nnoremap <Leader>R
                    \ :w<cr>
                    \ :!runhaskell %:p<cr>
    augroup END

    augroup language_specific_commands
        autocmd!
        autocmd FileType python nnoremap <Leader>b
                    \ Oimport pdb; pdb.set_trace()<esc>
    augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 07. Plugin Configuration
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Netrw Explorer
     nnoremap <leader>e :Explore<cr>
     nnoremap <leader>v :Vexplore<cr>
     nnoremap <leader>t :Texplore<cr>
     let g:netrw_liststyle=0      " Set default view style
     let g:netrw_banner=1        " Toggle banner
     let g:netrw_altv=1          " Open files on right
     let g:netrw_preview=1       " Open previews vertically
     let g:netrw_list_hide= '.*\.swp$,.*\.pyc'

    " Statusline config
    " let g:airline#extensions#tabline#enabled = 0
    let g:lightline = {
        \ 'colorscheme': 'nord',
        \ 'active': {
        \   'left': [[ 'mode', 'paste' ],
        \            [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
        \   },
        \ 'component_function': {
        \   'gitbranch': 'fugitive#head'
        \   },
        \ }

    " Rainbow Parentheses
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
    " \ ['gray',        'RoyalBlue3'],
    " \ ['black',       'SeaGreen3'],

    " Syntastic
    " set statusline+=%#warningmsg#
    " set statusline+=%{SyntasticStatuslineFlag()}
    " set statusline+=%*

    " let g:syntastic_always_populate_loc_list = 1
    " let g:syntastic_auto_loc_list = 1
    " let g:syntastic_check_on_open = 1
    " let g:syntastic_check_on_wq = 0
    " let g:syntastic_mode_map = {
    "     \ "mode": "active",
    "     \ "active_filetypes": [],
    "     \ "passive_filetypes": ["scala"]
    "     \ }
    " let g:syntastic_python_checkers = ['mypy', 'flake8']

    " ALE
    let g:ale_open_list = 1
    let g:ale_linters = {
    \   'python': ['pylint'],
    \}

    " Autoformat
    noremap <leader>af :Autoformat<CR>
    let g:formatdef_scalafmt = '"scalafmt --config=$HOME/.scalafmt.conf --stdin 2>/dev/null"'
    let g:formatters_scala = ['scalafmt']
    let g:autoformat_verbosemode = 1

    " Autotags
    let g:autotagTagsFile=".tags"

    """" Python Plugins
    " Python Syntax
    let python_highlight_all = 1

    """" Scala Plugins
    " Scala documentation
    let g:scala_scaladoc_indent = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 08. NeoVim Config
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:python_host_prog='~/.virtualenvs/nvim2/bin/python'
    let g:python3_host_prog='~/.virtualenvs/nvim3/bin/python'
