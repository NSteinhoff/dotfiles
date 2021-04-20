command! Qfedit execute (empty(getbufinfo('^QF$')) ? 'edit QF' : 'buffer ^QF$')

nnoremap <silent> <Plug>(qf-edit) <CMD>QfEdit<CR>
