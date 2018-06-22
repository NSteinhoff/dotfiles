" ---------------------------------------------------------
" vim-zen section
" ---------------------------------------------------------
    if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin('~/.vim/plugged')
    Plug 'w0rp/ale'
    Plug 'tpope/vim-fugitive'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'vim-python/python-syntax'
    Plug 'Vimjas/vim-python-pep8-indent'
    Plug 'luochen1990/rainbow'

    Plug 'andreypopp/vim-colors-plain'
    Plug 'andreasvc/vim-256noir'
    Plug 'owickstrom/vim-colors-paramount'
    Plug 'vietjtnguyen/toy-blocks'

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

"----------------------------------- Basics -----------------------------------
    if !has('nvim')
        unlet! skip_defaults_vim
        source $VIMRUNTIME/defaults.vim
        set autoread
        set ttyfast                                 " Indicate a fast terminal connection
    endif
    set undodir=$HOME/.vim/undo
    set undofile
    filetype plugin indent on
    set lazyredraw                              " Only redraw when necessary
    set ffs=unix,dos,mac                        " Unix as standard file type
    set encoding=utf8                           " Standard encoding
    set hidden                                  " Allow hidden buffers

    " Put backups and swapfiles in '.vim-tmp'
    set backup
    set swapfile
    set backupdir=~/.vim-tmp
    set directory=~/.vim-tmp


"------------------------------------- UI -------------------------------------
    set laststatus=2                            " Always show the statusbar
    set nonumber                                " Don't show line numbers
    set norelativenumber                        " Don't show line numbers relative to current cursor position
    set numberwidth=4                           " Width of the number gutter
    set list                                    " Enable list mode showing 'listchars'
    set listchars=nbsp:¬,tab:»·,trail:·         " Configure which characters to show in list mode
    set foldcolumn=1                            " Show gutter that shows the foldlevel
    set scrolloff=3


    " Colorscheme
    set t_Co=256
    set background=dark
    try
        if !empty($VIM_COLORSCHEME)
            colorscheme $VIM_COLORSCHEME
        else
            " Prefered default colorscheme
            colorscheme toy-blocks
        endif
    catch /^Vim\%((\a\+)\)\=:E185/
        " Colorschemes not installed yet
        " This happens when first installing bundles
        colorscheme default
    endtry

"--------------------------------- Searching ----------------------------------
    set hlsearch                                " Highlight search results
    set wildmode=longest:full,full              " Default matching, but also start wildmenu
    set tags+=./tags;,.tags;                    " Search for .tags' files upwards
    " set path=.,,**                              " Search downwards from current directory

    " Ignore certain files when searching
    set wildignore+=*.egg-info/*
    set wildignore+=*.git/*
    set wildignore+=*.pyc
    set wildignore+=*.swp
    set wildignore+=*.tox/*
    set wildignore+=*.zip
    set wildignore+=*__pycache__/*
    set wildignore+=*db/*
    set wildignore+=*devenv/*
    set wildignore+=*docs/*
    set wildignore+=*log/*
    set wildignore+=*node_modules/*
    set wildignore+=*runenv/*
    set wildignore+=*target/*
    set wildignore+=*vendor/*
    set wildignore+=*venv/*


"----------------------------------- Grep -------------------------------------
    " Use external 'grep' tool to search for patterns recursively
    if executable('ag')
        set grepprg=ag\ --vimgrep\ $*
        set grepformat=%f:%l:%c:%m
    else
        set grepprg=grep\ -n\ -r\ --exclude='*.swp'\ --exclude='.tags'\ $*\ /dev/null
        set grepformat&
    endif

"---------------------------------- Folding -----------------------------------
    set foldmethod=indent                       " Fold by indent
    set foldignore=                             " Fold everything
    set foldnestmax=8                           " Set the maximum number of folds


"---------------------------------- Editing -----------------------------------
    " Indenting
    set shiftwidth=4                            " Number of spaces to indent
    set shiftround                              " When indenting, always round to the nearest 'shiftwidth'
    set autoindent                              " Automatically indent new lines
    " set smartindent                             " Be smart about indenting new lines

    " Wrapping
    set textwidth=0                             " Do not break long lines
    set nowrap                                  " Do not wrap long lines

    " Tabbing
    set tabstop=4                               " Number of spaces for each <Tab>
    set softtabstop=4                           " Make <Tab>s feel like tabs while using spaces when inserting
    set expandtab                               " Expand <Tab> into spaces

    " Autocompletion
    set complete-=t                             " Don't scan tags
    set complete-=i                             " Don't scan included files

"--------------------------------- Statusline ---------------------------------
    " set statusline=[%{&ff}]%y\ %F%m%r%h%w%=%{gutentags#statusline()}%{fugitive#statusline()}[%l:%v\|%p%%]


"---------------------------------- Browsing ----------------------------------
    let g:netrw_liststyle=0                     " Set default view style [thin|long|wide|tree]
    let g:netrw_banner=0                        " Show banner no/yes [0|1]
    let g:netrw_altv=1                          " Open vertical splits on the right, not left
    let g:netrw_preview=1                       " Open previews in a vertical split, not horizontal
    let g:netrw_list_hide= '.*\.swp$,.*\.pyc'   " File patterns to hide from the list


"------------------------------ Custom Commands -------------------------------

    "--- General ---
    " Switch to alternative buffer
    nnoremap <leader>b :e #<cr>

    " Escape Terminal mode
    " tnoremap <esc> <c-\><c-n>

    " Insert newline
    nnoremap <leader>o mpo<esc>`p
    nnoremap <leader>O mpO<esc>`p

    " Navigate splits
    nnoremap <c-j> <c-w><c-j>
    nnoremap <c-k> <c-w><c-k>
    nnoremap <c-l> <c-w><c-l>
    nnoremap <c-h> <c-w><c-h>

    " Remove highlights of last search results
    nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

    " Close Preview window
    nnoremap <silent> <C-Space> :pclose<CR>

    " Make arrow keys do something useful -- resizing windows
    nnoremap <silent> <Left> :vertical resize -1<CR>
    nnoremap <silent> <Right> :vertical resize +1<CR>
    nnoremap <silent> <Up> :resize +1<CR>
    nnoremap <silent> <Down> :resize -1<CR>

    "--- Searching ---
    " Search for the name under the cursor in all files with the same extension
    nnoremap <leader>* *:vimgrep //j **/*%:e \| bo copen<CR>

    " Search for the last search pattern in all files with the same extension
    nnoremap <leader>/ :vimgrep //j **/*%:e \| bo copen<CR>

    " Closing parenthesis
    inoremap {{<cr> {<cr>}<esc>O
    inoremap [[<cr> [<cr>]<esc>O
    inoremap ((<cr> (<cr>)<esc>O

    " Insert current date and time as 'ctime'
    inoremap ddc <C-R>=strftime("%c")<CR>
    " Insert current date ctime 'YYYY-MM-DD'
    inoremap ddd <C-R>=strftime("%Y-%m-%d")<CR>

    "--- List item navigation
    " Argument list
    nnoremap [a :previous<CR>
    nnoremap ]a :next<CR>
    nnoremap [A :first<CR>
    nnoremap ]A :last<CR>

    " Buffer list
    nnoremap [b :bprevious<CR>
    nnoremap ]b :bnext<CR>
    nnoremap [B :bfirst<CR>
    nnoremap ]B :blast<CR>

    " Quickfix list
    nnoremap [q :cprevious<CR>
    nnoremap ]q :cnext<CR>
    nnoremap [Q :cfirst<CR>
    nnoremap ]Q :clast<CR>

    " Location list
    nnoremap [l :lprevious<CR>
    nnoremap ]l :lnext<CR>
    nnoremap [L :lfirst<CR>
    nnoremap ]L :llast<CR>

    " Tag match list
    nnoremap [t :tprevious<CR>
    nnoremap ]t :tnext<CR>
    nnoremap [T :tfirst<CR>
    nnoremap ]T :tlast<CR>


"----------------------------- Filetype settings ------------------------------
    augroup filetype_settings
        autocmd!
        autocmd BufNewFile,BufRead *.boot set ft=clojure
        autocmd BufNewFile,BufRead *.taskpaper set ft=taskpaper
        autocmd FileType gitcommit set colorcolumn=70
        autocmd FileType markdown set colorcolumn=100
        autocmd FileType python,haskell,scala,lisp,clojure set colorcolumn=80
        autocmd FileType python set formatprg=yapf
        autocmd FileType json set formatprg=python\ -m\ json.tool
        autocmd FileType lisp set shiftwidth=2 tabstop=2 softtabstop=2
        autocmd FileType scala set formatprg=scalafmt\ --config\ /Users/nikosteinhoff/.scalafmt.conf\ --stdin
        autocmd Filetype taskpaper set noexpandtab
    augroup END

"---------------------------- Rainbow Parentheses ----------------------------
    let g:rainbow_active = 1    "0 if you want to enable it later via :RainbowToggle


"-------------------------------- ALE linting ---------------------------------
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


"--------------------------------- Gutentags ----------------------------------
    let g:gutentags_ctags_tagfile='.tags'


"--------------------------------- Python-Vim ---------------------------------
    let g:python_highlight_all = 1


"---------------------------------- Snippets ----------------------------------
    augroup filetype_commands
        autocmd!
        au BufEnter *vimrc nnoremap <buffer> <cr> :source %<cr>
        au FileType python nnoremap <buffer> _bp oimport pdb; pdb.set_trace()<Esc>
        au FileType python nnoremap <buffer> _BP Oimport pdb; pdb.set_trace()<Esc>
    augroup END


"------------------------------- Error Format ---------------------------------
    set errorformat+=%f\|%l\ col\ %c\|%m    " Allow reading error lists from buffers
