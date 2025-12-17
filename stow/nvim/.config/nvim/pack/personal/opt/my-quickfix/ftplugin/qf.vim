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
nnoremap <buffer> <expr> cF qf#isqf() ? (qf#isloc() ? ':L' : ':C')..'filter!<space>' : ''

" Manage lists
nnoremap <silent> <buffer> !! <cmd>call qf#only()<cr>
nnoremap <silent> <buffer> X <cmd>call qf#cut()<cr>
nnoremap <silent> <buffer> Y <cmd>call qf#yank()<cr>
nnoremap <silent> <buffer> P <cmd>call qf#paste()<cr>

" Edit current list
nnoremap <silent> <buffer> dd <cmd>call qf#delete()<cr>
vnoremap <silent> <buffer> d :call qf#delete()<cr>

" Search and Replace entries
nnoremap <buffer> <expr> gs (qf#isloc() ? ':ldo' : ':cdo')..' s/'
nnoremap <buffer> <expr> gS (qf#isloc() ? ':ldo' : ':cdo')..' s/<c-r>//<c-r>/'
vnoremap <buffer> <expr> gS (qf#isloc() ? 'y:ldo' : 'y:cdo')..' s/\C\V<c-r>=escape(@", '\/')<cr>/
nnoremap <buffer> <expr> gU (qf#isloc() ? ':lfdo' : ':cfdo')..' update<cr>'
