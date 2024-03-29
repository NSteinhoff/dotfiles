if get(g:, 'loaded_showmarks')|finish|endif
let g:loaded_showmarks = 1

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

function s:enable()
    augroup my-showmarks
        if !exists('#my-showmarks#BufEnter,CursorHold')
            autocmd BufEnter,CursorHold * silent! call s:place_signs()
        endif
    augroup END
endfunction

function s:disable()
    if exists('#my-showmarks#BufEnter,CursorHold')
        autocmd! my-showmarks
        augroup! my-showmarks
        call sign_unplace(s:sign_group)
    endif
endfunction

command! NoShowMarks call s:disable()
command! ShowMarks call s:enable()

""" Show global marks
command! -nargs=* Marks execute 'try | '(<q-args> != '' ? 'filter :'..<q-args>..':' : '')..' marks ABCDEFGHIJKLMNOPQRSTUVWXYZ | catch | endtry'
command! -nargs=* -bang -complete=customlist,s:complete_marks Delmarks execute 'delmarks '..(<bang>0 ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : <q-args>)

nnoremap <plug>(list-marks) <cmd>Marks<cr>

ShowMarks
