set packpath+=~/dev/dotfiles/3rd

function! s:packpath() abort
    return split(&packpath, ',')[0]..'/pack/personal/opt/'
endfunction

function! s:packfiles(arglead, cmdline, cursorpos) abort
    let paths = globpath(s:packpath(), '**/*.vim', 0, 1)
                \ + globpath(s:packpath(), '**/*.lua', 0, 1)
    call filter(paths, { _, v -> v =~ a:arglead })
    call map(paths, { _, v -> fnamemodify(v, ':.')[strlen(s:packpath()) : ]})
    call uniq(paths)
    call sort(paths)
    return paths
endfunction

function s:editpackage(name, mods, split)
    let paths = s:packfiles(a:name, '', '')

    if empty(paths)
        echo a:name . ' not found.'
        return
    endif

    execute a:mods . ' '.(a:split ? 'split' : 'edit').' ' . s:packpath() . paths[0]
endfunction

command! -nargs=? -complete=customlist,<sid>packfiles PackEdit call s:editpackage(<q-args>, '<mods>', 0)
command! -nargs=? -complete=customlist,<sid>packfiles PackSplit call s:editpackage(<q-args>, '<mods>', 1)
