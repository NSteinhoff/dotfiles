setlocal cursorline

" Remove some global mappings that do not make sense in the quickfix list
nnoremap <buffer> - -
nnoremap <buffer> <CR> <CR>
nnoremap <buffer> <SPACE> <SPACE>
nnoremap <buffer> <BS> <C-W>c

nnoremap <buffer> <nowait> > <CMD>call qf#cycle_lists(1)<CR>
nnoremap <buffer> <nowait> < <CMD>call qf#cycle_lists(0)<CR>

execute 'nnoremap <silent> <buffer> p     <CMD>execute line(".").."'..(qf#isloc() ? 'll' : 'cc')..'"<bar>wincmd p<CR>'
execute 'nnoremap <silent> <buffer> <C-N> <CMD>'..(qf#isloc() ? 'l' : 'c')..'next<bar>wincmd p<CR>'
execute 'nnoremap <silent> <buffer> <C-P> <CMD>'..(qf#isloc() ? 'l' : 'c')..'prev<bar>wincmd p<CR>'

if qf#isloc()|finish|endif
nnoremap <silent> <buffer> <Tab> <CMD>call qf#mark()<CR>
vnoremap <silent> <buffer> <Tab> :call qf#mark()<CR>
nnoremap <silent> <buffer> J <CMD>call qf#mark()<CR>j
nnoremap <silent> <buffer> K k<CMD>call qf#mark()<CR>
nnoremap <silent> <buffer> <S-Tab> <CMD>call qf#clear_marks()<CR>

nnoremap <silent> <buffer> <bar> <CMD>call qf#filter(0, v:count)<CR>
nnoremap <silent> <buffer> - <CMD>call qf#filter(1, v:count)<CR>

nnoremap <silent> <buffer> !! <CMD>call qf#only()<CR>
nnoremap <silent> <buffer> !$ <CMD>call qf#duplicate()<CR>
