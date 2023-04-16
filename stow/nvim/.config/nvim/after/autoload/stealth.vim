let s:matches = {}

function stealth#on()
    let m = get(s:matches, win_getid(), {})
    if (!empty(m))|return|endif

    let start_markers = &comments
        \->split(',')
        \->filter({ _, v -> v =~ '^:' })
        \->map({_, v -> strcharpart(v, 1)})

    for marker in start_markers
        let pattern = '\(^\|\s\)\s*\zs'..escape(marker, '*$~|.')..'.*$'
        let m = {'id': matchadd('Conceal', pattern, 99, -1, {'conceal': '~'}), 'cole': &l:cole}
        let s:matches[win_getid()] = m
    endfor

    let &l:cole = 1
endfunction

function stealth#off()
    let m = get(s:matches, win_getid(), {})
    if (empty(m))|return|endif
    let &l:cole = m.cole
    call matchdelete(m.id)
    unlet s:matches[win_getid()]
endfunction

function stealth#update()
    let m = get(s:matches, win_getid(), {})
    if (empty(m))|return|endif
    call stealth#off()
    call stealth#on()
endfunction

function stealth#toggle()
    let m = get(s:matches, win_getid(), {})
    if (empty(m))
        call stealth#on()
    else
        call stealth#off()
    endif
endfunction

function stealth#status()
    let m = get(s:matches, win_getid(), {})
    if (empty(m))
        return ''
    else
        return 'STEALTH'
    endif
endfunction
