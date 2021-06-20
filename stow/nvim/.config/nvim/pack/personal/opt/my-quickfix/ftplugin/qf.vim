setlocal cursorline
setlocal scrolloff=0

" Remove some global mappings that do not make sense in the quickfix list
nnoremap <buffer> - -
nnoremap <buffer> <CR> <CR>
nnoremap <buffer> <SPACE> <SPACE>
nnoremap <buffer> <BS> <C-W>c

" Cycle through lists
nnoremap <buffer> <nowait> > <CMD>call qf#cycle_lists(1)<CR>
nnoremap <buffer> <nowait> < <CMD>call qf#cycle_lists(0)<CR>

" Preview errors
nnoremap <silent> <buffer> <SPACE> <CMD>call qf#preview(0)<CR>
nnoremap <silent> <buffer> <C-SPACE> <CMD>call qf#preview(0)<CR>
nnoremap <silent> <buffer> p <CMD>call qf#preview(0)<CR>
nnoremap <silent> <buffer> <C-N> <CMD>call qf#preview(1)<CR>
nnoremap <silent> <buffer> <C-P> <CMD>call qf#preview(-1)<CR>

" Mark errors for filtering
nnoremap <silent> <buffer> <Tab> <CMD>call qf#mark()<CR>
vnoremap <silent> <buffer> <Tab> :call qf#mark()<CR>
nnoremap <silent> <buffer> J <CMD>call qf#mark()<CR>j
nnoremap <silent> <buffer> K k<CMD>call qf#mark()<CR>
nnoremap <silent> <buffer> <S-Tab> <CMD>call qf#clear_marks()<CR>

" Filter based on marks/selection (creates new lists)
nnoremap <silent> <buffer> zn <CMD>call qf#filter(0, 1)<CR>
nnoremap <silent> <buffer> zN <CMD>call qf#filter(1, 1)<CR>
vnoremap <silent> <buffer> zn :call qf#mark()<CR><CMD>call qf#filter(0, 1)<CR>
vnoremap <silent> <buffer> zN :call qf#mark()<CR><CMD>call qf#filter(1, 1)<CR>

" Manage lists
nnoremap <silent> <buffer> !! <CMD>call qf#only()<CR>
nnoremap <silent> <buffer> D <CMD>call qf#delete()<CR>
nnoremap <silent> <buffer> Y <CMD>call qf#yank()<CR>
nnoremap <silent> <buffer> P <CMD>call qf#paste()<CR>

" Edit current list
nnoremap <silent> <buffer> dd <CMD>call qf#mark()<CR><CMD>call qf#swap(1)<CR>
nnoremap <silent> <buffer> yy <CMD>call qf#mark()<CR><CMD>call qf#swap(0)<CR>
vnoremap <silent> <buffer> d :call qf#mark()<CR><CMD>call qf#swap(1)<CR><CMD>execute min([line("'<"), line("$")])<CR>
vnoremap <silent> <buffer> y :call qf#mark()<CR><CMD>call qf#swap(0)<CR>
