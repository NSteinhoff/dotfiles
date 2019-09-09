"--------------------------------- Helpers ----------------------------------{{{
augroup settings
    autocmd!
    autocmd! BufWritePost init.vim source % | echomsg "Settings updated"
augroup END
" }}}

"--------------------------------- Behavior ---------------------------------{{{
set hidden
set updatetime=100
set wildmode=list:longest,full
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
set tags+=./.git/tags,./.git/tags;,.git/tags,.git/tags;
" }}}

"------------------------------- Autoread -------------------------------------{{{
augroup autoread_settings
    autocmd!
    autocmd CursorHold * silent! checktime
augroup END
"}}}

"--------------------------------- Display ----------------------------------{{{
set foldmethod=indent

set scrolloff=1
set sidescrolloff=5
set nowrap

set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

set cursorline
augroup active_window_indicator
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

augroup terminal_statusline
    autocmd!
    autocmd TermOpen * setlocal statusline=%{b:term_title}
augroup END

try
    colorscheme minimalist
catch E185
    echo "Colorscheme not installed."
endtry
"}}}

"-------------------------------- Providers ---------------------------------{{{
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog  = expand('~').'/.pyenv/versions/py3nvim/bin/python'
let g:node_host_prog = expand('~').'/.nvm/versions/node/v12.10.0/bin/neovim-node-host'
" }}}

"--------------------------------- Mappings ---------------------------------{{{
let mapleader = '\'

" Clear search highlighting
if maparg('<C-Space>', 'n') ==# ''
    nnoremap <silent> <C-Space> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
endif
" }}}

"--------------------------------- Plugins ----------------------------------{{{
if empty(glob('~/.config/nvim/pack/minpac/opt/minpac'))
    silent !git clone https://github.com/k-takata/minpac.git
        \ ~/.config/nvim/pack/minpac/opt/minpac
endif
packadd minpac
if exists('*minpac#init')
    call minpac#init()
    " minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " Add plugins below:

    call minpac#add('neomake/neomake')
    call minpac#add('nsteinhoff/vim-compilers')
    call minpac#add('nsteinhoff/vim-differ')
    call minpac#add('nsteinhoff/vim-pomodoro')

    call minpac#add('dikiaap/minimalist')
    call minpac#add('jdsimcoe/abstract.vim')

    call minpac#add('sheerun/vim-polyglot')
endif

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
" }}}

" vim:foldmethod=marker textwidth=0
