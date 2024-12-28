if get(g:, 'loaded_marks')|finish|endif
let g:loaded_marks = 1

let s:sign_group = 'marks'
let s:signs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '\ze')
let s:signs = map(s:signs, {_, v -> "'"..v})
call sign_define(map(copy(s:signs), { i, v -> {'name': v, 'text': v, 'texthl': 'Special'} }))

function s:marks()
    let global = getmarklist()->filter({_, v -> index(s:signs, v.mark) != -1 && v.pos[0] == bufnr()})
    let local = getmarklist('')->filter({_, v -> index(s:signs, v.mark) != -1})
    let marks = (local + global)->map({ _, v -> {'mark': v.mark, 'line': v.pos[1], 'col': v.pos[2]}})
    return marks
endfunction

function s:complete_marks(arglead, cmdline, cursorpos)
    return filter(map(getmarklist(), { _, m -> m.mark[1:] }), {_, m -> m =~ "[A-Z]" })
endfunction

function s:mark2sign(mark)
    return {
        \ 'buffer': '%',
        \ 'group': s:sign_group,
        \ 'id': char2nr(a:mark.mark[1:]),
        \ 'lnum': a:mark.line,
        \ 'name': a:mark.mark,
        \ }
endfunction

function s:place_signs()
    call sign_unplace(s:sign_group)
    let signs = map(s:marks(), { _, v -> s:mark2sign(v) })
    call sign_placelist(signs)
endfunction

function s:enabled()
    return exists('#my-showmarks')
endfunction

function s:toggle()
    if s:enabled()
        call s:disable()
    else
        call s:enable()
    endif
endfunction

function s:enable()
    if s:enabled()|return|endif
    aug my-showmarks
    au!
    au BufEnter,CursorHold * silent! call s:place_signs()
    aug END
endfunction

function s:disable()
    if !s:enabled()|return|endif
    au! my-showmarks
    aug! my-showmarks
    call sign_unplace(s:sign_group)
endfunction

command! NoShowMarks call s:disable()
command! ShowMarks call s:enable()
command! ToggleMarks call s:toggle()

""" Show global marks
command! -nargs=* -complete=customlist,s:complete_marks Marks execute 'marks '..(empty(<q-args>) ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : <q-args>)
command! -nargs=* -bang -complete=customlist,s:complete_marks Delmarks execute 'delmarks '..(<bang>0 ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : <q-args>) | echo "Cleared Marks!"

nnoremap <plug>(list-marks) <cmd>Marks<cr>

ShowMarks
