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

    "--- General
    Plug 'luochen1990/rainbow'                      " Rainbow parentheses
    Plug 'junegunn/goyo.vim'                        " Minimal UI for focused writing
    Plug 'jpalardy/vim-slime'                       " Send selection to tmux pane
    Plug 'tpope/vim-dispatch'                       " Run jobs in the background

    "--- Colorschemes
    Plug 'trevordmiller/nova-vim'
    Plug 'patstockwell/vim-monokai-tasty'

    "--- Languages
    Plug 'sheerun/vim-polyglot'                     " Collection of language plugins
    Plug 'junegunn/vader.vim'                       " Vimscript testing

    "--- Compilers
    Plug 'nsteinhoff/vim-compilers'                 " Collection of compilers

    "--- Markdown
    Plug 'dhruvasagar/vim-table-mode'               " Table mode for markdown documents

    call plug#end()


"--- Configuration ---
    "--- Netrw Browser
    let g:netrw_liststyle=0                     " Set default view style [thin|long|wide|tree]
    let g:netrw_banner=0                        " Show banner no/yes [0|1]
    let g:netrw_altv=1                          " Open vertical splits on the right, not left
    let g:netrw_preview=1                       " Open previews in a vertical split, not horizontal
    let g:netrw_list_hide= '.*\.swp$,.*\.pyc'   " File patterns to hide from the list


    "--- Rainbow Parentheses
    let g:rainbow_active = 1    "0 if you want to enable it later via :RainbowToggle


    "--- SLIME
    let g:slime_target = "tmux"


    "--- Python-Vim
    let g:python_highlight_all = 1


    "--- Vim-Scala
    let g:scala_scaladoc_indent = 1
    let g:scala_use_default_keymappings = 0
