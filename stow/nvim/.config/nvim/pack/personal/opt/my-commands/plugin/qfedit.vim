command! Qfedit execute (empty(getbufinfo('^QF$')) ? 'edit QF' : 'buffer ^QF$')
command! Qfclear call setqflist([], 'f')

nnoremap <silent> <Plug>(qf-edit) <CMD>QfEdit<CR>
