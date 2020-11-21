function commander#tmake#makeprg(qargs) abort
    if &makeprg =~ '$\*'
        let makeprg = substitute(&makeprg, '$\*', a:qargs, '')
    else
        let makeprg = &makeprg.' '.a:qargs
    endif
    return substitute(makeprg, '%', expand('%'), '')
endfunction

function commander#tmake#shell_cmd(qargs) abort
    let makeprg = commander#tmake#makeprg(a:qargs)
    let tempfile = tempname()
    let cmd = 'echo '.shellescape(makeprg.' ...')
                \.' && '.makeprg.' '.&shellpipe.' '.tempfile
                \.'; mv '.tempfile.' '.&errorfile
                \.'; sleep 2'
    return shellescape(cmd)
endfunction

function commander#tmake#kill_window(name) abort
    let id = s:window_id(a:name)

    if id != -1
        call system('tmux kill-window -t '.id)
        return v:shell_error == 0
    endif

    return -1
endfunction

function s:rename_window(name, newname)
    let id = s:window_id(a:name)

    if id != -1
        system('tmux rename-window -t '.id.' 'a:newname)
        return v:shell_error == 0
    endif

    return -1
endfunction

function s:tmux_windows() abort
    let windows = []

    for line in systemlist('tmux list-windows -F "#{window_id}:#{window_name}"')
        let components = split(line, '^@\d\+\zs:')
        let id = components[0]
        let name = components[1]
        call add(windows, {'name': name, 'id': id})
    endfor

    return windows
endfunction

function s:window_id(name) abort
    let windows = s:tmux_windows()

    for window in windows
        if window['name'] == a:name
            return window['id']
        endif
    endfor

    return -1
endfunction

function s:has_window(name) abort
    let names = map(s:tmux_windows(), {_, v -> v['name']})
    return index(names, a:name) != -1
endfunction
