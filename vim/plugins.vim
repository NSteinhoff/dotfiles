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

" Ranger file browser
if !empty(system('which ranger'))
    Plug 'francoiscabrol/ranger.vim'
    let g:ranger_map_keys = 0
    map <leader>r = :Ranger<CR>
    map <leader>R = :RangerWorkingDirectory<CR>
endif

" Send selected text to tmux pane
" Very useful for REPL based development (Clojure)
Plug 'jpalardy/vim-slime'
let g:slime_target = "tmux"

"--- Builds / Make / Dispatch{{{
let s:enable_dispatch = v:false
if s:enable_dispatch
    " Run compilers or other external commands in the
    " background.
    " Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'
    let g:dispatch_compilers = {
            \ 'pytest': 'pytest',
            \ 'pipenv run pytest': 'pytest',
            \ 'pipenv run pytest --tb=short -q': 'pytest',
            \ 'pipenv run mypy': 'mypy'
        \ }

    nnoremap <F5> :Make<CR>
    nnoremap <F6> :Make!<CR>
    nnoremap <F9> :Dispatch<CR>
    nnoremap <F10> :Dispatch!<CR>

    augroup filetype_dispatch_defaults
        autocmd!
        autocmd FileType python let b:dispatch = 'mypy --strict %'
    augroup END
endif
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

"--- Language Server Protocol{{{
let s:use_coc = v:false
if s:use_coc
    source ~/dotfiles/vim/coc-setup.vim
    let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-yaml',
        \ 'coc-python',
        \ ]
endif

let s:use_ale = v:false
if s:use_ale
    Plug 'w0rp/ale'
    let g:ale_python_auto_pipenv = 1
    let g:ale_linters = {
    \ 'python': ['flake8', 'mypy']
    \ }
    let g:ale_fixers = {
    \ 'python': ['yapf']
    \ }
    nnoremap <leader>af :ALEFix<cr>
    nnoremap <leader>al :ALELint<cr>
endif

let s:use_lsp = v:true
if s:use_lsp
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
endif
"}}}

"--- Netrw Browser{{{
let g:netrw_liststyle=0                     " Set default view style [thin|long|wide|tree]
let g:netrw_banner=0                        " Show banner no/yes [0|1]
let g:netrw_altv=1                          " Open vertical split left/right [0|1]
let g:netrw_alto=0                          " Open vertical split left/right [0|1]
let g:netrw_altfile=0                       " CTRL-^ returns you to the last directory listing or edited file [0|1]
let g:netrw_preview=1                       " Open preview split type horizontal/vertical [0|1]
let g:netrw_list_hide='.*\.swp$,.*\.pyc'    " File patterns to hide from the list
let g:netrw_fastbrowse=0                    " Always refresh the listing
"}}}

call plug#end()
