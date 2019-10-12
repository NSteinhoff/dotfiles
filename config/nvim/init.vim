"--------------------------------- Helpers ----------------------------------{{{
augroup settings
    autocmd!
    " Source this file on write
    autocmd! BufWritePost init.vim source % "
augroup END

" Create an 80 column wide header starting at the current cursor position.
" The header text can be passed as an arguments or left blank to use the word
" under the cursor. With no argument or word under cursor, will simply draw
" the separator line.
function s:header(words)
    " Some constants
    let prefix = '"'
    let sep = '-'
    let cend = 80

    " Set the text that goes in-between the separators
    if a:words != ''
        let text = ' '.a:words.' '
    elseif expand('<cword>') != ''
        let text = ' '.expand('<cword>').' '
    else
        let text = ''
    endif

    " We start at the current cursor column, divide the rule into two
    " parts and fit the text in-between
    let cstart = col('.')
    let width = cend - cstart
    let sepwidth = (width - strlen(text)) / 2

    " Build the header line
    let header =
        \ repeat(' ', cstart-1)
        \ .prefix
        \ .repeat(sep, sepwidth)
        \ .text
        \ .repeat(sep, sepwidth)

    " Set the current line to the header and position the cursor at the end.
    call setline(line('.'), header)
    call cursor(line('.'), col('$'))
endfunction
command! -nargs=? Header call s:header(<q-args>)

"}}}

"--------------------------------- Behavior ---------------------------------{{{
set hidden
set updatetime=100
set wildmode=longest:full,full
set path=,,.
"}}}

"--------------------------------- Editing ----------------------------------{{{
" Tabs -> Spaces
set shiftwidth=4
set softtabstop=-1
set expandtab
"}}}

"----------------------------------- Tags -----------------------------------{{{
" Upward search from current file, then 'tags' in the working directory
" -> files dir (./xyz)
" -> upwards from file (./xyz;)
" -> cwd (xyz)
" -> upwards from cwd (xyz;)
" plain tags -> .git/tags
set tags=./tags,./tags;,tags,tags;

" I've set up a git hook that get's installed for all repositories that creates
" tags files on git actions that change the index (commits, checkouts, merges, etc.).
" This file lives in the .git/ directory.
set tags+=./.git/tags,./.git/tags;,.git/tags,.git/tags;
"}}}

"------------------------------- Autoread -------------------------------------{{{
augroup autoread_settings
    autocmd!
    autocmd CursorHold * silent! checktime
augroup END
"}}}

"--------------------------------- Display ----------------------------------{{{
set number
set inccommand=nosplit

set foldmethod=indent

set scrolloff=10
set sidescrolloff=5
set nowrap

set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+

" I've disabled the cursorline for now because i find it
" distracting, especially when reading man pages.
" Most colorschemes use statusline highlighting to indicate
" the active window. That is usually enough.
if v:false
    set cursorline
    augroup cursorline_in_active_window_only
        autocmd!
        autocmd WinEnter * set cursorline
        autocmd WinLeave * set nocursorline
    augroup END
endif

" Gracefully handle unavailable colorscheme.
" The desired colorscheme might not be installed yet. This happens
" after cloning and installing the dotfiles for the first time.
" Otherwise you'd have to click through the error messages manually.
try
    colorscheme gruvbox-material
    set background=dark
catch E185
    echo "Colorscheme not installed. Using the default colorscheme."
endtry
"}}}

"-------------------------------- Providers ---------------------------------{{{
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog  = expand('~').'/.pyenv/versions/py3nvim/bin/python'
let g:node_host_prog = expand('~').'/.nvm/versions/node/v12.10.0/bin/neovim-node-host'
"}}}

"---------------------------------- Commands --------------------------------{{{
" Send current S-Expression to repl FIFO file.
" nnoremap <c-c><c-c> vap:w >> ~/repl<cr>
augroup user
    autocmd!
    autocmd FileType clojure nnoremap <buffer> <space> :Eval<cr>
augroup END
"}}}

"--------------------------------- Mappings ---------------------------------{{{
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'

" Clear search highlighting
if maparg('<ESC>', 'n') ==# ''
    nnoremap <silent> <ESC> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
endif
"}}}

"--------------------------------- Plugins ----------------------------------{{{
" Install minpac as an optional package if it's not already installed.
if empty(glob('~/.config/nvim/pack/minpac/opt/minpac'))
    silent !git clone https://github.com/k-takata/minpac.git
        \ ~/.config/nvim/pack/minpac/opt/minpac
endif

" Minpac is only needed when doing changes to the plugins such as updating
" or deleting.
"
" Therefore, we don't need to always load it with
"
"   packadd minpac
"
" Instead the commands below add the package on demand.
if exists('*minpac#init')
    call minpac#init()
    " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " |||                   |||
    " ||| Add plugins below |||
    " vvv                   vvv

    " Runners:
    " Unsure whether to use 'neomake' or tpope's 'dispatch'.
    " 'neomake' seems simpler, and I'm not yet a heavy user.
    " One compiler / maker is usually enough.
    " 'neomake' also has the nice concept of local and global makers.
    call minpac#add('neomake/neomake')

    " REPL:
    " Tmux based REPL integration using 'tslime'
    call minpac#add('jgdavey/tslime.vim')

    " Clojure:
    call minpac#add('tpope/vim-fireplace')

    " Colorschemes:
    call minpac#add('dikiaap/minimalist')
    call minpac#add('jdsimcoe/abstract.vim')
    call minpac#add('sainnhe/gruvbox-material')

    " Ftplugings:
    call minpac#add('sheerun/vim-polyglot')
endif

" Load all packages in 'start/'
packloadall

" These commands load minpac on demand and get the list of plugins by sourcing this file
" before calling the respective minpac function for that task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
"}}}

"------------------------------------ REPL ------------------------------------{{{
" Send text block to tmux pane
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars
"}}}

"---------------------------------- Compiler ----------------------------------{{{
" Configure Neomake automake functionality
nnoremap <F5> :make<cr>
if v:false
    nnoremap <C-space> :Neomake!<cr>
else
    nnoremap <C-space> :make<cr>
endif
"}}}

" vim:foldmethod=marker textwidth=0
