
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" General settings
set history=50		    " keep 50 lines of command line history
set ruler		        " show the cursor position all the time
set showcmd		        " display incomplete commands
set incsearch		    " do incremental searching
set number              " show line numbers
set numberwidth=3       " set gutter column width
set cursorline          " highlight cursor line
set showmatch           " highlight matching braces
set wildmenu            " visual autocomplete for command menu
set incsearch           " search as you type

" Folding
set foldenable          " enable folding
set foldlevelstart=5    " open N number of folds by default
set foldnestmax=10      " limit number of nested folds
nnoremap <space> za


" Filetype specific
filetype plugin on
filetype indent on
set omnifunc=syntaxcomplete#Complete

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Custom Keymappings
" Movement testing
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk
nnoremap B ^
nnoremap E $
nnoremap gV `[v`]
inoremap jk <esc>

" Execute current file
nnoremap <C-p> :w<CR>:cd %:p:h<CR>:! ./%<CR>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Indentation
set autoindent		" always set autoindenting on
set tabstop=8           " tabstop width
set expandtab 		" tabs to spaces
set softtabstop=8	" tabs are 4 spaces
set shiftwidth=8	" shift by 4 spaces

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
