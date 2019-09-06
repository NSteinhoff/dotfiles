" vim:foldmethod=marker textwidth=0

"--------------------------------- Helpers ----------------------------------{{{
let s:use_vim_settings = 0
if s:use_vim_settings > 0
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vimrc
endif

augroup reload_settings
    autocmd!
    autocmd BufWritePost init.vim source %
augroup END
" }}}

"--------------------------------- Editing ----------------------------------{{{
" Tabs -> Spaces
set shiftwidth=4
set softtabstop=-1
set expandtab
" }}}

"----------------------------------- Tags -----------------------------------{{{
" Upward search from current file, then 'tags' in the working directory
set tags-=./tags tags-=./tags; tags^=./tags;
" }}}

"------------------------------- Autoread -------------------------------------{{{
set updatetime=100                          " Fire CursorHold event after X milliseconds
augroup autoread_settings
    autocmd!
    autocmd CursorHold * silent! checktime
augroup END
"}}}
"

"--------------------------------- Display ----------------------------------{{{
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
"}}}

"-------------------------------- Providers ---------------------------------{{{
let s:disable_providers = 1
if s:disable_providers > 0
    let g:loaded_python_provider = 1
    let g:loaded_python3_provider = 1
    let g:loaded_ruby_provider = 1
    let g:loaded_node_provider = 1
endif
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog  = expand('~').'/.pyenv/versions/py3nvim/bin/python'
let g:node_host_prog = expand('~').'/.nvm/versions/node/v12.10.0/bin/neovim-node-host'
" }}}

"--------------------------------- Mappings ---------------------------------{{{
" Clear search highlighting
if maparg('C-L', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>
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
endif

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
" }}}
