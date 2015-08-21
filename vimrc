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
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 01. General
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                    " get rid of Vi compatibility mode. SET FIRST!

" Managing Plugins
filetype off                        " required

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Bundles to install go here:
" Python Mode                       " Python mode with linter and code completion
Bundle 'klen/python-mode'

" Airline                           " Nice status line
Plugin 'bling/vim-airline'

" Fugitive                          " Git integration
Plugin 'fugitive.vim'

call vundle#end()                   " required

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. Events
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ffs=unix,dos,mac        " Unix as standard file type
set encoding=utf8           " Standard encoding
filetype plugin indent on   " filetype detection[ON] plugin[ON] indent[ON]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256                        " enable 256-color mode.
syntax enable                       " enable syntax highlighting (previously syntax on).
let python_highlight_all=1          " improved syntax highlighting
" colorscheme wombat256
colorscheme monokai                 " nice dark colorscheme
let g:airline_theme='molokai'
set background=dark
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                  " show line numbers
set numberwidth=6           " make the number gutter 6 characters wide
set cul                     " highlight current line
set laststatus=2            " last window always has a statusline
set incsearch               " But do highlight as you type your search.
set ignorecase              " Make searches case-insensitive.
set ruler                   " Always show info along bottom.
set showmatch               " Show matching braces
set visualbell              " Visual feedback
set scrolloff=7             " Vertical offset
set sidescrolloff=5         " Horizontal offset
set ttyfast                 " Faster
set showcmd                 " Show partial commands
set hlsearch
hi Search ctermbg=LightGray
hi Search ctermfg=Black
"
" Show funny characters
set list
set listchars=nbsp:¬,tab:»·,trail:·
"
" Wildmenu
set wildmenu                                        " command line completion
set wildmode=longest:full,full
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Text Formattingk/Layout
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent              " auto-indent
set tabstop=4               " tab spacing
set softtabstop=4           " unify
set shiftwidth=4            " indent/outdent by 4 columns
set shiftround              " always indent/outdent to the nearest tabstop
set expandtab               " use spaces instead of tabs
set cindent                 " automatically insert one extra level of indentation
set smarttab                " use tabs at the start of a line, spaces elsewhere
set nowrap                  " don't wrap text

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
" execute the current file with python
nnoremap <Leader>r :w<cr> :!python %<cr>
"
"
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
"
" PyMode Config
let g:pymode_run = 0
let g:pymode_run_bind = ''
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_show_doc_bind = 'K'
