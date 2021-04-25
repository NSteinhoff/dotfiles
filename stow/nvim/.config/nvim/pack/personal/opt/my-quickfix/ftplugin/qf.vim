" Remove some global mappings that do not make sense in the quickfix list
nnoremap <buffer> - -
nnoremap <buffer> <CR> <CR>
nnoremap <buffer> <SPACE> <SPACE>
nnoremap <buffer> <BS> <C-W>c

nnoremap <buffer> <nowait> <expr> > '<CMD>'..qf#cycle_lists(1)..'<CR>'
nnoremap <buffer> <nowait> <expr> < '<CMD>'..qf#cycle_lists(0)..'<CR>'

if qf#isloc()|finish|endif
nnoremap <silent> <buffer> <C-N> :cnext<CR><C-W>p
nnoremap <silent> <buffer> <C-P> :cprev<CR><C-W>p

nnoremap <buffer> <Tab> <CMD>call qf#mark()<CR>
vnoremap <buffer> <Tab> :call qf#mark()<CR>
nnoremap <buffer> <S-Tab> <CMD>call qf#clear_marks()<CR>
nnoremap <buffer> <bar> <CMD>call qf#filter(0, v:count)<CR>
nnoremap <buffer> !<bar> <CMD>call qf#filter(1, v:count)<CR>
nnoremap <buffer> !! <CMD>call qf#only()<CR>
nnoremap <buffer> !$ <CMD>call qf#duplicate()<CR>
