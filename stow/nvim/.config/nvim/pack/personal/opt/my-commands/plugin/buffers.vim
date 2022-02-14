" Open scratch buffer (with selected lines)
command! -range Scratch call buffers#scratch(<range> ? getline(<line1>, <line2>) : [])

" Go to alternative buffer
command! Balternative call buffers#alternative()

" Delete current buffer
command! Bdelete call buffers#delete(0)
command! Bwipe call buffers#delete(1)

" Delete all but the current buffer
command! -bang Bonly %bd<bang>|e#|bd#

" Open editable buffer list
command! Buffers execute &ft == 'qf' || <q-mods> =~ 'tab' ? 'tabedit BUFFERS' : 'edit BUFFERS'

" Open new buffers with same filetype
command! -nargs=? -complete=buffer Bnew let ft = &ft | new <args> | let &ft=ft
command! -nargs=? -complete=buffer Bvnew let ft = &ft | vnew <args> | let &ft=ft

nnoremap <silent> <plug>(buffers-edit-list) <cmd>Buffers<cr>
nnoremap <silent> <plug>(buffers-delete) <cmd>Bdelete<cr>
nnoremap <silent> <plug>(buffers-wipe) <cmd>Bwipe<cr>
nnoremap <silent> <plug>(buffers-only) <cmd>Bonly<cr>
nnoremap <silent> <plug>(buffers-scratch) <cmd>Scratch<cr>
vnoremap <silent> <plug>(buffers-scratch) :Scratch<cr>
nnoremap <silent> <plug>(buffers-new) <cmd>Bnew<cr>
nnoremap <silent> <plug>(buffers-vnew) <cmd>Bvnew<cr>
nnoremap <silent> <plug>(buffers-alternative) <cmd>Balternative<cr>
