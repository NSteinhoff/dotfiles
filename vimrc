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
" 01. General
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
    """"" Total Conversion """""
        " Python Mode                       " Python mode with linter
        Plugin 'klen/python-mode'           " and code completion

        " Haskell
        Plugin 'haskell.vim'


    """"" UI """""
        " Monokai
        Plugin 'lsdr/monokai'

        " Solarized
        Plugin 'altercation/vim-colors-solarized'

        " Airline                           " Nice status line
        Plugin 'vim-airline/vim-airline'
        Plugin 'vim-airline/vim-airline-themes'

        " Fugitive                          " Git integration
        Plugin 'fugitive.vim'

        " GitGutter                         " Sow git diff stats in gutter
        Plugin 'airblade/vim-gitgutter'

        " Toggle Background
        Plugin 'https://github.com/saghul/vim-colortoggle.git'

    """"" General Functionality """""
        " csv.vim
        Plugin 'csv.vim'                    " Added functionality for reading
                                            " and editing .csv files
        " Text alignment
        Plugin 'Tabular'

        " FuzzyFinder
        Plugin 'ctrlp.vim'                  " Fuzzy file finder

        " Virtualenv
        Plugin 'virtualenv.vim'

        " Send text to tmux
        Plugin 'jgdavey/tslime.vim'

    """""""""""""""""""""""""""""""""""""
    call vundle#end()                   " required


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. Events
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set ffs=unix,dos,mac        " Unix as standard file type
    set encoding=utf8           " Standard encoding
    filetype plugin indent on   " filetype detection[ON] plugin[ON] indent[ON]


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set t_Co=256

    syntax enable                       " enable syntax highlighting
    let python_highlight_all=1          " improved syntax highlighting

    let g:solarized_termtrans = 1
    let g:solarized_termcolors=256
    try
    colorscheme solarized
    catch /^Vim\%((\a\+)\)\=:E185/
        " deal with it
    endtry
    let g:airline_theme='solarized'

    let g:default_background_type = "dark"
    let g:dark_colorscheme = "solarized"
    let g:light_colorscheme = "solarized"

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
    set foldmethod=indent       " how to determine folds
    set foldnestmax=2           " limit nested folds
    set foldignore=             " Set this to nothing to also fold python comments

    " Show funny characters
    set list
    set listchars=nbsp:¬,tab:»·,trail:·

    " Wildmenu
    set wildmenu                                        " command line completion
    set wildmode=longest:full,full
    set wildignore=*.swp,*.zip,*.pyc


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
    set smarttab                " use tabs at the start of a line, spaces
                                " elsewhere
    set nowrap                  " don't wrap text
    set backspace=2


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Custom Commands
"
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
    " disable Ex-mode
    map Q <Nop>
    "
    " faster exiting insert mode without having to leave the homerow
    inoremap jk <esc>
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

    " Toggle Background
    map <silent><F11> :ToggleBg<CR>

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
                    "\ :!ghc --make % && %:p:r<cr>
        " run linter
        autocmd FileType python nnoremap <Leader>l :PymodeLint<cr>
    augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 07. Plugin Configuration
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " PyMode Config
    let g:pymode_run = 0
    let g:pymode_run_bind = ''
    let g:pymode_lint_on_write = 1
    let g:pymode_lint_ignore = "C0325"
    let g:pymode_rope = 0
    let g:pymode_rope_lookup_project = 1
    let g:pymode_rope_complete_on_dot = 0
    let g:pymode_rope_show_doc_bind = '<leader>d'
    let g:pymode_rope_goto_definition_bind = '<leader>g'
    "
    " Netrw Explorer
     nnoremap <leader>e :Explore<cr>
     nnoremap <leader>v :Vexplore<cr>
     nnoremap <leader>t :Texplore<cr>
     let g:netrw_listtyle=0      " Set default view style
     let g:netrw_banner=1        " Toggle banner
     let g:netrw_altv=1          " Open files on right
     let g:netrw_preview=1       " Open previews vertically
     let g:netrw_list_hide= '.*\.swp$,.*\.pyc'

    " Airline Config
    let g:airline#extensions#tabline#enabled = 0
    let g:airline#extensions#syntastic#enabled = 1

    " tslime
    vmap <C-c><C-c> <Plug>SendSelectionToTmux
    nmap <C-c><C-c> <Plug>NormalModeSendToTmux
    nmap <C-c>r <Plug>SetTmuxVars
