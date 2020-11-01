let g:loaded_netrwPlugin = 1
augroup SANITIZE_netrw
    autocmd!
    " There seems to be a bug in netrw which sends a <space> after the '-' mapping
    autocmd Filetype netrw nnoremap <buffer> <SPACE> <SPACE>
augroup END
