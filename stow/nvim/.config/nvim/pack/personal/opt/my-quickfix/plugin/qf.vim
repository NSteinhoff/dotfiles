command! Qfedit execute (empty(getbufinfo('^QFEDIT$')) ? 'edit QFEDIT' : 'buffer ^QFEDIT$')
command! -nargs=* -bang Qfnew call qf#new(<q-args>, <bang>0)

nnoremap <silent> <Plug>(qf-edit) <CMD>QfEdit<CR>

nnoremap <silent> <Plug>(cycle-loc-forward) <CMD>call qf#cycle_loc(1)<CR>
nnoremap <silent> <Plug>(cycle-loc-backward) <CMD>call qf#cycle_loc(0)<CR>
nnoremap <silent> <Plug>(cycle-qf-forward) <CMD>call qf#cycle_qf(1)<CR>
nnoremap <silent> <Plug>(cycle-qf-backward) <CMD>call qf#cycle_qf(0)<CR>

nnoremap <silent> <Plug>(qf-new) <CMD>call qf#new('', v:count)<CR>
nnoremap <silent> <Plug>(qf-add) <CMD>call qf#add()<CR>
vnoremap <silent> <Plug>(qf-add) :call qf#add()<CR>
