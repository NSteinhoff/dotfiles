function fmt#fmt(yes = 0)
    let formatprg = ''

    let F = get(b:, 'formatprgfunc')
    if type(F) == v:t_func
        let formatprg = F()
    else
        let formatprg = get(b:, 'formatprg', &equalprg)
    endif

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

    let before = tempname()
    let after = tempname()
    call writefile(lines, before, 's')
    call writefile(formatted, after, 's')
    let diff = system(["diff", before, after])
    call delete(before)
    call delete(after)

    if empty(diff)
        echo "Already formatted"
        return
    endif

    let apply = 1

    if !a:yes
        echo diff
        let apply = confirm("Accept Changes?", "&Yes\n&No")
        redraw " Avoid hit-enter prompt
    endif


    if apply != 1
        echo "Okay then ..."
        return
    endif

    " Setting lines and then deleting dangling lines at the end avoids
    " jumping to the beginning of the buffer when undoing as would
    " happen with %delete -> append()
    call setline(1, formatted)
    undojoin
    call deletebufline(bufnr(), len(formatted) + 1, '$')

    echo "Formatted buffer"
endfunction

function fmt#fix(yes = 0)
    let fixprg = ''

    let F = get(b:, 'fixprgfunc')
    if type(F) == v:t_func
        let fixprg = F()
    else
        let fixprg = get(b:, 'fixprg', '')
    endif

    if empty(fixprg)
        echomsg "Abort: 'fixprg' unset"
        return
    endif

    let fixprg = expandcmd(escape(fixprg, '{}'))
    let lines = getline(0, '$')
    let result = systemlist(fixprg)

    if v:shell_error > 0
        echomsg "Error: fixprg '".fixprg."' exited with status ".v:shell_error
        return
    endif

    checktime
    echo "Fixed buffer"
endfunction
