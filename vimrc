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


    """"" UI """""
        " Airline                           " Nice status line
        Plugin 'bling/vim-airline'

        " Fugitive                          " Git integration
        Plugin 'fugitive.vim'

        " GitGutter                         " Sow git diff stats in gutter
        Plugin 'airblade/vim-gitgutter'


    """"" General Functionality """""
        " csv.vim
        Plugin 'csv.vim'                    " Added functionality for reading
                                            " and editing .csv files

        " FuzzyFinder
        Plugin 'ctrlp.vim'                  " Fuzzy file finder


        """"" Programming """""
        " Jedi-Vim
        " Plugin 'davidhalter/jedi-vim'       " Code completion and refactoring

        " Syntastic
        " Plugin 'scrooloose/syntastic'       " Syntax checking
                                            " Requires the chosen syntax checkers to be
                                            " installed (i.e. 'flake8' for python)


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
    set t_Co=256                        " enable 256-color mode.
    syntax enable                       " enable syntax highlighting
                                        " (previously syntax on)
    let python_highlight_all=1          " improved syntax highlighting
    " colorscheme wombat256
    colorscheme monokai                 " nice dark colorscheme
    let g:airline_theme='molokai'
    set background=dark
    " hi Folded ctermbg=234
    hi Folded ctermfg=138


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set lazyredraw              " only redraw if necessary
    set number                  " show line numbers
    set relativenumber          " show relative line numbers
    set numberwidth=4           " make the number gutter 4 characters wide
    set cul                     " highlight current line
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
    hi Search ctermbg=LightGray
    hi Search ctermfg=Black

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

    """ Python specific
    " Hightlight overlength
    " autocmd FileType python highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    " autocmd FileType python match OverLength /\%81v.\+/
    " Line break after 79 characters
    " autocmd FileType python setlocal textwidth=79


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
    " execute the current file with python
    nnoremap <Leader>R :w<cr> :!python %<cr>
    "
    " resync folding
    nnoremap <Leader>z :syn sync fromstart<cr>
    "
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 07. Plugin Configuration
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " PyMode Config
    let g:pymode_run = 0
    let g:pymode_run_bind = ''
    let g:pymode_lint_on_write = 1
    let g:pymode_lint_unmodified = 1
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
    "
    " Airline Config
    let g:airline#extensions#tabline#enabled = 0
    let g:airline#extensions#syntastic#enabled = 1
    "
    " Jedi-Vim
    " let g:jedi#popup_on_dot = 0
    " let g:jedi#show_call_signatures = 0
    " let g:jedi#use_splits_not_buffers = "left"
    "
    " Syntastic
    " let g:syntastic_auto_loc_list = 2
    " let g:syntastic_always_populate_loc_list = 0
    " let g:syntastic_loc_list_height = 5
    " let g:syntastic_python_checkers = ["flake8"]
