command! Qfedit execute (empty(getbufinfo('^QFEDIT$')) ? 'edit QFEDIT' : 'buffer ^QFEDIT$')

nnoremap <silent> <Plug>(qf-edit) <CMD>QfEdit<CR>

nnoremap <silent> <Plug>(cycle-loc-forward) <CMD>call qf#cycle_loc(1)<CR>
nnoremap <silent> <Plug>(cycle-loc-backward) <CMD>call qf#cycle_loc(0)<CR>
