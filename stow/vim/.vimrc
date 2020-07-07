silent source $VIMRUNTIME/defaults.vim

set hidden
set wildmode=longest:full,full
set path=,,.
set shiftwidth=4
set softtabstop=-1
set expandtab
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:+
set background=dark
set foldmethod=indent
set backspace=indent,eol,start
set modeline

colorscheme minimal

augroup settings
    autocmd!
    autocmd! BufWritePost .vimrc,vimrc source %
augroup END

packadd external                " enable external packages managed by minpac