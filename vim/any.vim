"file any.vim
set guioptions-=m
set guioptions-=T
set guioptions-=r
set lines=15
set columns=100
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile
autocmd QuitPre * %w !xsel -ib
