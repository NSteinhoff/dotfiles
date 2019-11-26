"file any.vim
set guioptions-=m
set guioptions-=T
set guioptions-=r
set lines=25
set columns=104     " 100 + 4 columns for the gutter
set buftype=nofile
set bufhidden=hide
set noswapfile
autocmd QuitPre * %w !xsel -ib
autocmd BufNew * r !xsel -op
