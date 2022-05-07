setlocal cursorline
setlocal scrolloff=0
setlocal nolist
setlocal nowrap

" Remove some global mappings that do not make sense in the quickfix list
nnoremap j j
nnoremap k k
nnoremap <buffer> - -
nnoremap <buffer> <cr> <cr>
nnoremap <buffer> <bs> <c-w>c
nnoremap <buffer> <space> <cr>

" Cycle through lists
nnoremap <buffer> <nowait> > <cmd>call qf#cycle_lists(1)<cr>
nnoremap <buffer> <nowait> < <cmd>call qf#cycle_lists(0)<cr>

" Mark errors for filtering
nnoremap <silent> <buffer> <tab> <cmd>call qf#mark()<cr>
vnoremap <silent> <buffer> <tab> :call qf#mark()<cr>
nnoremap <silent> <buffer> <s-tab> <cmd>call qf#clear_marks()<cr>

" Filter based on marks/selection (creates new lists)
nnoremap <silent> <buffer> zn <cmd>call qf#filter(0, 1)<cr>
nnoremap <silent> <buffer> zN <cmd>call qf#filter(1, 1)<cr>

" Filter based on regex
nnoremap <buffer> <expr> cf qf#isqf() ? (qf#isloc() ? ':L' : ':C')..'filter<space>' : ''
nnoremap <buffer> <expr> Cf qf#isqf() ? (qf#isloc() ? ':L' : ':C')..'filter!<space>' : ''

" Manage lists
nnoremap <silent> <buffer> !! <cmd>call qf#only()<cr>
nnoremap <silent> <buffer> X <cmd>call qf#cut()<cr>
nnoremap <silent> <buffer> Y <cmd>call qf#yank()<cr>
nnoremap <silent> <buffer> P <cmd>call qf#paste()<cr>

" Edit current list
nnoremap <silent> <buffer> dd <cmd>call qf#delete()<cr>
vnoremap <silent> <buffer> d :call qf#delete()<cr>
