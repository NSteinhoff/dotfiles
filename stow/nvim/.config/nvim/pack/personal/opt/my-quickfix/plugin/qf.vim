" Add the :Cfilter and :Lfilter commands
packadd cfilter

command! -nargs=* -bang Cnew call qf#new(<q-args>, <bang>0)
command! Cadd call qf#add()

command! Ctab if getqflist({'nr': 0}).nr|tab split|botright copen|only|else|echo "No quickfix list."|endif
command! Ltab if getloclist(0, {'nr': 0}).nr|tab split|botright lopen|only|else|echo "No location list."|endif

nnoremap <silent> <plug>(cycle-loc-forward) <cmd>call qf#cycle_loc(1)<cr>
nnoremap <silent> <plug>(cycle-loc-backward) <cmd>call qf#cycle_loc(0)<cr>
nnoremap <silent> <plug>(cycle-qf-forward) <cmd>call qf#cycle_qf(1)<cr>
nnoremap <silent> <plug>(cycle-qf-backward) <cmd>call qf#cycle_qf(0)<cr>
nnoremap <silent> <plug>(cycle-visible-forward) <cmd>call qf#cycle_visible(1)<cr>
nnoremap <silent> <plug>(cycle-visible-backward) <cmd>call qf#cycle_visible(0)<cr>

nnoremap <silent> <plug>(qf-new) <cmd>call qf#new('', v:count)<cr>
nnoremap <silent> <plug>(qf-add) <cmd>call qf#add()<cr>
vnoremap <silent> <plug>(qf-add) :call qf#add()<cr>
