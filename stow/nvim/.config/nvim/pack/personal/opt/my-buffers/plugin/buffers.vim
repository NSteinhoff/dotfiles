" Open scratch buffer (with selected lines)
command! -range Scratch call buffers#scratch(<range> ? getline(<line1>, <line2>) : [])
nnoremap <silent> <plug>(buffers-scratch) <cmd>Scratch<cr>
vnoremap <silent> <plug>(buffers-scratch) :Scratch<cr>

" Go to alternative buffer
command! Balternative call buffers#alternative()
nnoremap <silent> <plug>(buffers-alternative) <cmd>Balternative<cr>

" Delete current buffer
command! Bdelete call buffers#delete(0)
nnoremap <silent> <plug>(buffers-delete) <cmd>Bdelete<cr>
command! Bwipe call buffers#delete(1)
nnoremap <silent> <plug>(buffers-wipe) <cmd>Bwipe<cr>

" Delete all but the current buffer
command! -bang Bonly %bd<bang>|e#|bd#
nnoremap <silent> <plug>(buffers-only) <cmd>Bonly<cr>

" Open editable buffer list
command! Buffers execute &ft == 'qf' || <q-mods> =~ 'tab' ? 'tabedit BUFFERS' : 'edit BUFFERS'
nnoremap <silent> <plug>(buffers-edit-list) <cmd>Buffers<cr>

" Open new buffers with same filetype
command! -nargs=? -complete=buffer Bnew let ft = &ft | <mods> new <args> | let &ft=ft
nnoremap <silent> <plug>(buffers-new) <cmd>Bnew<cr>
nnoremap <silent> <plug>(buffers-vnew) <cmd>vertical Bnew<cr>
nnoremap <silent> <plug>(buffers-tnew) <cmd>tab Bnew<cr>
