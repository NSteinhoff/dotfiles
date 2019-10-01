"--------------------------------- Helpers ----------------------------------{{{
augroup settings
    autocmd!
    " Source this file on write
    autocmd! BufWritePost init.vim source % | echomsg "Settings updated"
augroup END
" }}}

"--------------------------------- Behavior ---------------------------------{{{
set hidden
set updatetime=100
set wildmode=list:longest,full
set path=,,.
"}}}

"--------------------------------- Editing ----------------------------------{{{
" Tabs -> Spaces
set shiftwidth=4
set softtabstop=-1
set expandtab
" }}}

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
" }}}

"------------------------------- Autoread -------------------------------------{{{
augroup autoread_settings
    autocmd!
    autocmd CursorHold * silent! checktime
augroup END
"}}}

"--------------------------------- Display ----------------------------------{{{
set number
set inccommand=split

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
catch E185
    echo "Colorscheme not installed. Using the default colorscheme."
endtry
"}}}

"-------------------------------- Providers ---------------------------------{{{
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog  = expand('~').'/.pyenv/versions/py3nvim/bin/python'
let g:node_host_prog = expand('~').'/.nvm/versions/node/v12.10.0/bin/neovim-node-host'
" }}}

"--------------------------------- Mappings ---------------------------------{{{
" Explicitly map the <leader> key. Otherwise some plugins use their own default.
let mapleader = '\'

" Clear search highlighting
" I used to just use <space> to remove the highlights, but I've started using
" <space> for adhoc mapping stuff that I need to repeat frequently.
" E.g. run tests, execute the current file, etc.
if maparg('<C-Space>', 'n') ==# ''
    nnoremap <silent> <C-Space> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
endif
" }}}

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
"       ':packadd minpac'
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

    " Colorschemes:
    call minpac#add('dikiaap/minimalist')
    call minpac#add('jdsimcoe/abstract.vim')
    call minpac#add('sainnhe/gruvbox-material')

    " Ftplugings:
    call minpac#add('sheerun/vim-polyglot')
endif

" These commands load minpac on demand and get the list of plugins by sourcing this file
" before calling the respective minpac function for that task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
" }}}

" vim:foldmethod=marker textwidth=0
