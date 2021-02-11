command! -nargs=? -complete=file FileFinder execute
            \ (empty(getbufinfo('^FILES$')) ? 'edit FILES' : 'buffer ^FILES$')
            \| call setline(1, <q-args>) | 1 | doau TextChanged

nnoremap <silent> <Plug>(filefinder-new) <CMD>FileFinder<CR>i
nnoremap <silent> <expr> <Plug>(filefinder-here) '<CMD>FileFinder '..expand('%:.:h')..'/<CR>A'
