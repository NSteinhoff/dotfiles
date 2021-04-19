function s:isloc()
    return getwininfo(win_getid())[0].loclist == 1
endfunction

function s:cyclelists(forward)
    let curr = s:isloc() ? getloclist(0, {'nr': 0}).nr : getqflist({'nr': 0}).nr
    let last = s:isloc() ? getloclist(0, {'nr': '$'}).nr : getqflist({'nr': '$'}).nr
    let rewind = last - 1

    let prefix = s:isloc() ? 'l' : 'c'
    let step = a:forward ? (curr == last ? 'older'..rewind : 'newer')
                       \ : (curr == 1    ? 'newer'..rewind : 'older')

    return prefix..step
endfunction

nnoremap <buffer> <CR> <CR>
nnoremap <buffer> <BS> <C-W>c
nnoremap <buffer> <SPACE> <SPACE>
nnoremap <buffer> <C-N> <C-N>
nnoremap <buffer> <C-P> <C-P>
nnoremap <buffer> <nowait> <expr> > '<CMD>'..<SID>cyclelists(1)..'<CR>'
nnoremap <buffer> <nowait> <expr> < '<CMD>'..<SID>cyclelists(0)..'<CR>'
