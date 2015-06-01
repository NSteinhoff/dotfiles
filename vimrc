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
set nocompatible         " get rid of Vi compatibility mode. SET FIRST!

" Managing Plugins
filetype off                " required 

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Bundles to install go here
" Python Mode
Bundle 'klen/python-mode'


call vundle#end()           "required

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. Events
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]

" Enable omnicompletion (to use, hold Ctrl+X then Ctrl+O while in Insert mode.
set ofu=syntaxcomplete#Complete

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256                " enable 256-color mode.
syntax enable               " enable syntax highlighting (previously syntax on).
let python_highlight_all=1
" colorscheme wombat256      " set colorscheme
colorscheme monokai
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                  " show line numbers
set numberwidth=6           " make the number gutter 6 characters wide
set cul                     " highlight current line
set laststatus=2            " last window always has a statusline
set nohlsearch              " Don't continue to highlight searched phrases.
set incsearch               " But do highlight as you type your search.
set ignorecase              " Make searches case-insensitive.
set ruler                   " Always show info along bottom.
set showmatch               " Show matching braces
set visualbell              " Visual feedback
set scrolloff=7             " Vertical offset
set sidescrolloff=5        " Horizontal offset
set ttyfast                 " Faster
set showcmd                 " Show partial commands
" Show funny characters
set list
set listchars=nbsp:¬,tab:»·,trail:·
" Statusline
set statusline=                                     " Override default
set statusline+=%2*\ %f\ %m\ %r%*                   " Show filename/path
set statusline+=%3*%=%*                             " Set right-side status info after this line
set statusline+=%4*%l/%L:%v%*                       " Set <line number>/<total lines>:<column>
set statusline+=%5*\ %*
" Wildmenu
set wildmenu
" Folding
" set foldmethod=syntax
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Text Formattingk/Layout
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent            " auto-indent
set tabstop=4             " tab spacing
set softtabstop=4         " unify
set shiftwidth=4          " indent/outdent by 2 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
set smartindent           " automatically insert one extra level of indentation
set smarttab              " use tabs at the start of a line, spaces elsewhere
set nowrap                " don't wrap text

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Custom Commands
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map Q <Nop>
inoremap jk <esc>
nnoremap <Leader>r :w<cr> :!python %<cr>
nnoremap <Leader>z :syn sync fromstart<cr>
"
" PyMode Config
let g:pymode_run = 0
let g:pymode_run_bind = ''
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_show_doc_bind = 'K'
