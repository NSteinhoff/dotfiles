let s:packdir_personal = expand('~/.vim/pack/personal/')

function! s:packfiles(arglead, cmdline, cursorpos)
    let paths = glob(s:packdir_personal.'**/'.a:arglead.'**', 0, 1)
    call filter(paths, { _, val -> val =~ '\.vim$' })
    call uniq(paths)
    call sort(paths)
    return map(paths, { _, val -> substitute(val, expand(s:packdir_personal), "", "") })
endfunction

command! -nargs=? -complete=customlist,<SID>packfiles PackEdit
    \ execute 'edit '.s:packdir_personal.<q-args>

" vim: foldmethod=marker
