function! s:packpath() abort
    return split(&packpath, ',')[0]
endfunction

function! s:packtypes(arglead, cmdline, cursorpos) abort
    let types = ['start', 'opt']
    call filter(types, { _, v -> v =~ a:arglead })
    return types
endfunction

function! s:packfiles(arglead, cmdline, cursorpos) abort
    let paths = globpath(s:packpath(), 'pack/personal/**/*.vim', 0, 1)
                \ + globpath(s:packpath(), 'pack/personal/**/*.lua', 0, 1)
    call filter(paths, { _, v -> v =~ a:arglead })
    call map(paths, { _, v -> fnamemodify(v, ':.') })
    call uniq(paths)
    call sort(paths)
    return paths
endfunction

function s:editpackage(name, mods)
    let paths = s:packfiles(a:name, '', '')

    if empty(paths)
        echo a:name . ' not found.'
        return
    endif

    execute a:mods . ' split ' . paths[0]
endfunction

command! -nargs=? -complete=customlist,<SID>packfiles PackEdit call s:editpackage(<q-args>, '<mods>')
