setlocal cursorline
setlocal scrolloff=0

" Remove some global mappings that do not make sense in the quickfix list
nnoremap <buffer> - -
nnoremap <buffer> <cr> <cr>
nnoremap <buffer> <space> <space>
nnoremap <buffer> <bs> <c-w>c

" Cycle through lists
nnoremap <buffer> <nowait> > <cmd>call qf#cycle_lists(1)<cr>
nnoremap <buffer> <nowait> < <cmd>call qf#cycle_lists(0)<cr>

" Preview errors
nnoremap <silent> <buffer> <space> <cmd>call qf#preview(0)<cr>
nnoremap <silent> <buffer> <c-space> <cmd>call qf#preview(0)<cr>
nnoremap <silent> <buffer> p <cmd>call qf#preview(0)<cr>
nnoremap <silent> <buffer> <c-n> <cmd>call qf#preview(1)<cr>
nnoremap <silent> <buffer> <c-p> <cmd>call qf#preview(-1)<cr>

" Mark errors for filtering
nnoremap <silent> <buffer> <tab> <cmd>call qf#mark()<cr>
vnoremap <silent> <buffer> <tab> :call qf#mark()<cr>
nnoremap <silent> <buffer> J <cmd>call qf#mark()<cr>j
nnoremap <silent> <buffer> K k<cmd>call qf#mark()<cr>
nnoremap <silent> <buffer> <s-tab> <cmd>call qf#clear_marks()<cr>

" Filter based on marks/selection (creates new lists)
nnoremap <silent> <buffer> zn <cmd>call qf#filter(0, 1)<cr>
nnoremap <silent> <buffer> zN <cmd>call qf#filter(1, 1)<cr>
vnoremap <silent> <buffer> zn :call qf#mark()<cr><cmd>call qf#filter(0, 1)<cr>
vnoremap <silent> <buffer> zN :call qf#mark()<cr><cmd>call qf#filter(1, 1)<cr>

" Manage lists
nnoremap <silent> <buffer> !! <cmd>call qf#only()<cr>
nnoremap <silent> <buffer> X <cmd>call qf#cut()<cr>
nnoremap <silent> <buffer> Y <cmd>call qf#yank()<cr>
nnoremap <silent> <buffer> P <cmd>call qf#paste()<cr>

" Edit current list
nnoremap <silent> <buffer> dd <cmd>call qf#delete()<cr>
vnoremap <silent> <buffer> d :call qf#delete()<cr>
