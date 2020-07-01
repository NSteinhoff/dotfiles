let s:packdir_personal = expand('~/.vim/pack/personal/')

function! s:packfiles(arglead, cmdline, cursorpos)
    let paths = uniq(sort(glob(s:packdir_personal.'**/'.a:arglead.'**', 0, 1)))
    let Tail = { _, val -> substitute(val, expand(s:packdir_personal), "", "") }
    return map(paths, Tail)
endfunction

command! -nargs=? -complete=customlist,<SID>packfiles PackEdit
    \ execute 'edit '.s:packdir_personal.<q-args>

" vim: foldmethod=marker
