function! s:packfiles(arglead, cmdline, cursorpos) abort
    let paths = globpath(&packpath, 'pack/**/*.vim', 0, 1)
    call filter(paths, { _, v -> v =~ a:arglead })
    call map(paths, { _, v -> fnamemodify(v, ':.') })
    call uniq(paths)
    call sort(paths)
    return paths
endfunction

command! -nargs=? -complete=customlist,<SID>packfiles PackEdit
    \ execute 'edit '.<q-args>
