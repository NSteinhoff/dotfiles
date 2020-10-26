function! s:packpath() abort
    return split(&packpath, ',')[0]
endfunction

function! s:packtypes(arglead, cmdline, cursorpos) abort
    let types = ['start', 'opt']
    call filter(types, { _, v -> v =~ a:arglead })
    return types
endfunction

function! s:packfiles(arglead, cmdline, cursorpos) abort
    let paths = globpath(s:packpath(), 'pack/**/*.vim', 0, 1)
    call filter(paths, { _, v -> v =~ a:arglead })
    call map(paths, { _, v -> fnamemodify(v, ':.') })
    call uniq(paths)
    call sort(paths)
    return paths
endfunction

function! s:packages(packtype) abort
    let packtype = a:packtype == '' ? '*' : a:packtype
    let pattern =  'pack/*/' . packtype . '/*'
    let paths = globpath(s:packpath(), pattern, 0, 1)
    call map(paths, { _, v -> fnamemodify(v, ':~') })
    echo join(paths, "\n")
endfunction

command! -nargs=? -complete=customlist,<SID>packfiles PackEdit
    \ execute 'edit '.<q-args>
command! -nargs=? -complete=customlist,<SID>packtypes PackList
    \ call <SID>packages(<q-args>)
