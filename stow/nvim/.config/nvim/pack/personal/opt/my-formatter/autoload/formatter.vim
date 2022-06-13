function formatter#fmt()
    let formatprg = get(b:, 'formatprg', &formatprg)
    if empty(formatprg)
        echomsg "Abort: 'formatprg' unset"
        return
    endif

    let formatprg = expandcmd(escape(formatprg, '{}'))
    let lines = getline(0, '$')
    let formatted = systemlist(formatprg, lines)

    if v:shell_error > 0
        for line in formatted
            echomsg line
        endfor
        echomsg "Error: formatprg '".formatprg."' exited with status ".v:shell_error
        return
    endif

    if formatted != lines
        " Setting lines and then deleting dangling lines at the end avoids
        " jumping to the beginning of the buffer when undoing as would
        " happen with %delete -> append()
        call setline(1, formatted)
        undojoin
        call deletebufline('%', len(formatted) + 1, '$')
        silent update
    endif

    echo "Formatted buffer"
endfunction

function formatter#fix()
    if empty(get(b:, 'fixprg', ''))
        echomsg "Abort: 'fixprg' unset"
        return
    endif

    let fixprg = expandcmd(escape(b:fixprg, '{}'))
    let lines = getline(0, '$')
    let result = systemlist(fixprg)

    if v:shell_error > 0
        echomsg "Error: fixprg '".fixprg."' exited with status ".v:shell_error
        return
    endif

    checktime
    echo "Fixed buffer"
endfunction
