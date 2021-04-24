function qf#isloc()
    return getwininfo(win_getid())[0].loclist == 1
endfunction

function qf#cyclelists(forward)
    let curr = qf#isloc() ? getloclist(0, {'nr': 0}).nr : getqflist({'nr': 0}).nr
    let last = qf#isloc() ? getloclist(0, {'nr': '$'}).nr : getqflist({'nr': '$'}).nr
    if last == 1 | return | endif
    let rewind = last - 1

    let prefix = qf#isloc() ? 'l' : 'c'
    let step = a:forward ? (curr == last ? 'older'..rewind : 'newer')
                       \ : (curr == 1    ? 'newer'..rewind : 'older')

    return prefix..step
endfunction
