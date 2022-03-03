command! -nargs=? -complete=file FileFinder execute
            \ (empty(getbufinfo('^FILES$')) ? 'edit FILES' : 'buffer ^FILES$')
            \| call setline(1, <q-args>) | 1 | doau TextChanged


nnoremap <silent> <plug>(filefinder-new) <cmd>FileFinder<cr>i
