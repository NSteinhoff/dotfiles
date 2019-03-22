" vim:foldmethod=marker

" PLUGINS
" -------

"--- Install Plug ---
if empty(glob('~/.vim/autoload/plug.vim'))
silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


"--- Plugin List ---
call plug#begin('~/.vim/plugged')

"--- General{{{
" Rainbow parentheses
" Highlights matching parentheses in different colors
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

" Send selected text to tmux pane
" Very useful for REPL based development (Clojure)
Plug 'jpalardy/vim-slime'
let g:slime_target = "tmux"

Plug 'tpope/vim-dispatch'
"}}}

"--- Colorschemes{{{
Plug 'patstockwell/vim-monokai-tasty'
Plug 'dikiaap/minimalist'
Plug 'jdsimcoe/abstract.vim'
Plug 'romainl/Apprentice'
Plug 'romainl/flattened'
Plug 'keith/parsec.vim'
Plug 'zeis/vim-kolor'
Plug 'lifepillar/vim-solarized8'
Plug 'joshdick/onedark.vim'
"}}}

"--- Languages{{{

" Collection of language plugins
Plug 'sheerun/vim-polyglot'
let g:python_highlight_all = 1
let g:scala_scaladoc_indent = 1
let g:scala_use_default_keymappings = 0

" Testing framework for Vimscript
Plug 'junegunn/vader.vim'
"}}}

"--- Compilers{{{
Plug 'nsteinhoff/vim-compilers'                 " Collection of compilers
"}}}

"--- Markdown{{{
Plug 'dhruvasagar/vim-table-mode'               " Table mode for markdown documents
"}}}

"--- Language Server Protocol{{{
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
"}}}

"--- Netrw Browser{{{
let g:netrw_liststyle=0                     " Set default view style [thin|long|wide|tree]
let g:netrw_banner=1                        " Show banner no/yes [0|1]
let g:netrw_altv=1                          " Open vertical splits on the right, not left
let g:netrw_preview=1                       " Open previews in a vertical split, not horizontal
let g:netrw_list_hide= '.*\.swp$,.*\.pyc'   " File patterns to hide from the list
let g:netrw_fastbrowse=0
"}}}

call plug#end()
