"file any.vim
set guioptions-=m
set guioptions-=T
set guioptions-=r
set lines=25
set columns=104     # 100 + 4 columns for the gutter
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile
autocmd QuitPre * %w !xsel -ib
