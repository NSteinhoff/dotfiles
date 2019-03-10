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

    "--- IDE features
    Plug 'w0rp/ale'                                 " Asynchronous linting engine

    "--- Colorschemes
    Plug 'trevordmiller/nova-vim'
    Plug 'patstockwell/vim-monokai-tasty'

    "--- Languages
    Plug 'sheerun/vim-polyglot'                     " Collection of language plugins
    Plug 'junegunn/vader.vim'                       " Vimscript testing

    "--- Compilers
    Plug 'nsteinhoff/pytest-vim-compiler'           " Pytest compiler

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


    "--- ALE
        " There seems to be an issue where ALE starts linting a file when it is first
        " loaded, which I haven't been able to disable.
        " This causes major slowdowns when searching through a bunch of files with `:vimgrep`.
        " Workaround for now is to toggle ALE on/off.
        nnoremap <leader>al :ALELint<cr>
        nnoremap <leader>af :ALEFix<cr>
        let g:ale_enabled = 1
        let g:ale_open_list = 1

        " When to lint
        let g:ale_lint_on_enter = 1                 " When you open a new or modified buffer
        let g:ale_lint_on_save = 1                  " When you save a buffer
        let g:ale_lint_on_filetype_changed = 1      " When the filetype changes for a buffer
        let g:ale_lint_on_insert_leave = 0          " When you leave insert mode
        let g:ale_lint_on_text_changed = 'never'    " When you modify a buffer
        let g:ale_lint_delay = 200                  " ... lint after x ms

        let g:ale_linters = {}
        let g:ale_linters.python = ['flake8']
        let g:ale_linters.haskell = ['stack-ghc']

        let g:ale_fixers = {
        \  'scala': ['scalafmt'],
        \  'python': ['yapf']
        \}


    "--- SLIME
        let g:slime_target = "tmux"


    "--- Python-Vim
        let g:python_highlight_all = 1


    "--- Vim-Scala
        let g:scala_scaladoc_indent = 1
        let g:scala_use_default_keymappings = 0
