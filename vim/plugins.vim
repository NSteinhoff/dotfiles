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
    Plug 'w0rp/ale'
    Plug 'tpope/vim-fugitive'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'luochen1990/rainbow'

    "--- Colors
    Plug 'andreypopp/vim-colors-plain'
    Plug 'andreasvc/vim-256noir'
    Plug 'owickstrom/vim-colors-paramount'
    Plug 'vietjtnguyen/toy-blocks'

    "--- Python
    Plug 'vim-python/python-syntax'
    Plug 'Vimjas/vim-python-pep8-indent'

    " Plugin 'junegunn/goyo.vim'
    " Plugin 'airblade/vim-gitgutter'
    " Plugin 'tpope/vim-surround'
    " Plugin 'townk/vim-autoclose'
    " Plugin 'tpope/vim-commentary'
    " Plugin 'morhetz/gruvbox'
    " Plugin 'junegunn/fzf'
    " Plugin 'neomake/neomake'
    " Plugin 'scrooloose/nerdtree'
    " Plugin 'ervandew/supertab'
    " Plugin 'prakashdanish/vimport'
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


    "--- ALE
        " There seems to be an issue where ALE starts linting a faile when it is first
        " loaded, which I haven't been able to disable.
        " This causes major slowdowns when searching through a bunch of files with `:vimgrep`.
        " Workaround for now is to toggle ALE on/off.
        nnoremap <leader>l :ALELint<cr>
        let g:ale_enabled = 1
        let g:ale_open_list = 1

        " When to lint
        let g:ale_lint_delay = 1000
        let g:ale_lint_on_enter = 1                 " When you open a new or modified buffer
        let g:ale_lint_on_save = 1                  " When you save a buffer
        let g:ale_lint_on_filetype_changed = 1      " When the filetype changes for a buffer
        let g:ale_lint_on_insert_leave = 1          " When you leave insert mode
        let g:ale_lint_on_text_changed = 'never'    " When you modify a buffer

        let g:ale_linters = {
            \   'python': ['flake8', 'pycodestyle'],
            \   'haskell': ['stack-ghc'],
            \}


    "--- Gutentags
        let g:gutentags_ctags_tagfile='.tags'


    "--- Python-Vim
        let g:python_highlight_all = 1
