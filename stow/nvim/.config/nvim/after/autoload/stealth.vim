let s:matches = {}

function stealth#on()
    let m = get(s:matches, win_getid(), {})
    if (!empty(m))|return|endif
    let pattern = '\(^\|\s\)\s*\zs'..substitute(escape(&commentstring, '*$~|.')..'$', '%s', '.\*', '')
    let m = {'id': matchadd('Conceal', pattern, 99, -1, {'conceal': '~'}), 'cole': &l:cole}
    let s:matches[win_getid()] = m
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
