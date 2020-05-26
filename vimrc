" -------------------------------- Defaults ----------------------------------{{{

if !has('nvim')
    silent source $VIMRUNTIME/defaults.vim
    runtime ftplugin/man.vim
endif

"}}}


" --------------------------------- Behavior ---------------------------------{{{

map <left> <Nop>
map <right> <Nop>
map <up> <Nop>
map <down> <Nop>

set modeline
set hidden
set updatetime=100
set wildmode=longest:full,full
set path=,,.

"}}}


" --------------------------------- Editing ----------------------------------{{{

" Tabs -> Spaces
set shiftwidth=4
set softtabstop=-1
set expandtab

" Set 'formatoptions'  to break comment  lines but not other  lines, and
" insert the comment leader when hitting <CR> or using "o".
set formatoptions-=t
set formatoptions+=croql

"}}}


" --------------------------------- Display ----------------------------------{{{
set laststatus=0
set nonumber
set foldmethod=indent

set scrolloff=10
set sidescrolloff=5
set nowrap

set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+

set background=dark

"}}}


" --------------------------------- Helpers ----------------------------------{{{

augroup settings
    autocmd!
    " Source this file on write
    autocmd! BufWritePost .vimrc,vimrc source % "
augroup END

"}}}


" vim:foldmethod=marker textwidth=0
