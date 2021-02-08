command! -nargs=? FileFinder execute
            \ (empty(getbufinfo('^FILES$')) ? 'edit FILES' : 'buffer ^FILES$')
            \| call setline(1, <q-args>) | 1 | doau TextChanged

nnoremap <silent> <Plug>(filefinder-new) <CMD>FileFinder<CR>i
