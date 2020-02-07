"file any.vim
set guioptions-=m
set guioptions-=T
set guioptions-=r
setlocal lines=25
setlocal columns=104            " 100 + 4 columns for the gutter
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile
" '%yank +' does not work for some reason, so we opt for xsel. This needs to use pbcopy for Mac.
autocmd QuitPre * %w !xsel -ib
0put *
$d                              " delete the last line, it's always empty
