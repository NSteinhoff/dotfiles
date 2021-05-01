setlocal cursorline
setlocal scrolloff=0

command -buffer Mark call qf#mark()

" Remove some global mappings that do not make sense in the quickfix list
nnoremap <buffer> - -
nnoremap <buffer> <CR> <CR>
nnoremap <buffer> <SPACE> <SPACE>
nnoremap <buffer> <BS> <C-W>c

nnoremap <buffer> <nowait> > <CMD>call qf#cycle_lists(1)<CR>
nnoremap <buffer> <nowait> < <CMD>call qf#cycle_lists(0)<CR>

nnoremap <silent> <buffer> p <CMD>call qf#preview(0)<CR>
nnoremap <silent> <buffer> <C-N> <CMD>call qf#preview(1)<CR>
nnoremap <silent> <buffer> <C-P> <CMD>call qf#preview(-1)<CR>

if qf#isloc()|finish|endif
nnoremap <silent> <buffer> !! <CMD>call qf#only()<CR>
nnoremap <silent> <buffer> !$ <CMD>call qf#duplicate()<CR>

nnoremap <silent> <buffer> <Tab> <CMD>call qf#mark()<CR>
vnoremap <silent> <buffer> <Tab> :call qf#mark()<CR>
nnoremap <silent> <buffer> J <CMD>call qf#mark()<CR>j
nnoremap <silent> <buffer> K k<CMD>call qf#mark()<CR>
nnoremap <silent> <buffer> <S-Tab> <CMD>call qf#clear_marks()<CR>

nnoremap <silent> <buffer> zn <CMD>call qf#filter(0, v:count)<CR>
nnoremap <silent> <buffer> zN <CMD>call qf#filter(1, v:count)<CR>
vnoremap <silent> <buffer> zn :call qf#mark()<CR><CMD>call qf#filter(0)<CR>
vnoremap <silent> <buffer> zN :call qf#mark()<CR><CMD>call qf#filter(1)<CR>

nnoremap <silent> <buffer> dd <CMD>call qf#mark()<CR><CMD>call qf#swap(1)<CR>
nnoremap <silent> <buffer> yy <CMD>call qf#mark()<CR><CMD>call qf#swap(0)<CR>
vnoremap <silent> <buffer> d :call qf#mark()<CR><CMD>call qf#swap(1)<CR>
vnoremap <silent> <buffer> y :call qf#mark()<CR><CMD>call qf#swap(0)<CR>
