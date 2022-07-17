let s:matches = {}

function s:stealth_on()
    let m = get(s:matches, win_getid(), {})
    if (!empty(m))|return|endif
    let pattern = '\(^\|\s\)\zs\s*'..substitute(escape(&commentstring, '*$~|.')..'$', '%s', '.\*', '')
    let m = {'id': matchadd('Conceal', pattern, 99, -1, {'conceal': '~'}), 'cole': &l:cole}
    let s:matches[win_getid()] = m
    let &l:cole = 1
endfunction

function s:stealth_off()
    let m = get(s:matches, win_getid(), {})
    if (empty(m))|return|endif
    let &l:cole = m.cole
    call matchdelete(m.id)
    unlet s:matches[win_getid()]
endfunction

function s:stealth_update()
    let m = get(s:matches, win_getid(), {})
    if (empty(m))|return|endif
    call s:stealth_off()
    call s:stealth_on()
endfunction

function s:stealth_toggle()
    let m = get(s:matches, win_getid(), {})
    if (empty(m))
        call s:stealth_on()
    else
        call s:stealth_off()
    endif
endfunction

command! Stealth call s:stealth_on()
command! NoStealth call s:stealth_off()
command! StealthToggle call s:stealth_toggle()

augroup stealth
    autocmd!
    " Update the match for the current buffer's commentstring
    autocmd BufEnter * call s:stealth_update()
augroup END
