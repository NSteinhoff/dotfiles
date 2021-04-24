command! Qfedit execute (empty(getbufinfo('^QFEDIT$')) ? 'edit QFEDIT' : 'buffer ^QFEDIT$')

nnoremap <silent> <Plug>(qf-edit) <CMD>QfEdit<CR>
