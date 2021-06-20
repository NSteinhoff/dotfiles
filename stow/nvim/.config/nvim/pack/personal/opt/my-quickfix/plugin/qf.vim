command! -nargs=* -bang Cnew call qf#new(<q-args>, <bang>0)
command! Cadd call qf#add()

command! Ctab if getqflist({'nr': 0}).nr|tab split|copen|only|else|echo "No quickfix list."|endif
command! Ltab if getloclist(0, {'nr': 0}).nr|tab split|lopen|only|else|echo "No location list."|endif

nnoremap <silent> <Plug>(cycle-loc-forward) <CMD>call qf#cycle_loc(1)<CR>
nnoremap <silent> <Plug>(cycle-loc-backward) <CMD>call qf#cycle_loc(0)<CR>
nnoremap <silent> <Plug>(cycle-qf-forward) <CMD>call qf#cycle_qf(1)<CR>
nnoremap <silent> <Plug>(cycle-qf-backward) <CMD>call qf#cycle_qf(0)<CR>

nnoremap <silent> <Plug>(qf-new) <CMD>call qf#new('', v:count)<CR>
nnoremap <silent> <Plug>(qf-add) <CMD>call qf#add()<CR>
vnoremap <silent> <Plug>(qf-add) :call qf#add()<CR>
