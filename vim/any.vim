"file any.vim
set guioptions-=m
set guioptions-=T
set guioptions-=r
setlocal lines=25
setlocal columns=104     " 100 + 4 columns for the gutter
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile
autocmd QuitPre * %w !xsel -ib
0read !xsel -op
