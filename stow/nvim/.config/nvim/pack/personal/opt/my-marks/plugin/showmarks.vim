if get(g:, 'loaded_showmarks')|finish|endif
let g:loaded_showmarks = 1
let g:marker_enabled = 1

let s:sign_group = 'marks'
let s:signs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '\ze')
call sign_define(map(copy(s:signs), { i, v -> {'name': v, 'text': v, 'texthl': 'Special'} }))

function s:marks()
    let marks = execute("marks")
    let marks = split(marks, "\n")[1:]
    let marks = map(marks, { _, v -> split(v)})
    let marks = map(marks, { _, v -> {'mark': v[0], 'line': v[1], 'col': v[2], 'file/text': join(v[3:], ' ')}})

    let local = filter(copy(marks), { _, v -> v['mark'] =~# '[a-z]'})
    let global = filter(copy(marks), { _, v -> v['mark'] =~# '[A-Z]'})

    return {'local': local, 'global': global}
endfunction

function s:mark2sign(mark)
    return {
        \ 'buffer': '%',
        \ 'group': s:sign_group,
        \ 'id': char2nr(a:mark.mark),
        \ 'lnum': a:mark.line,
        \ 'name': a:mark.mark,
        \ }
endfunction

function s:place_signs()
    call sign_unplace(s:sign_group)
    let local = map(s:marks().local, { _, v -> s:mark2sign(v) })
    call sign_placelist(local)
endfunction

function s:enable()
    let g:marker_enabled = 1
    call s:update()
endfunction

function s:disable()
    let g:marker_enabled = 0
    call s:update()
endfunction

function s:update()
    if get(g:, 'marker_enabled')
        call s:place_signs()
    else
        call sign_unplace(s:sign_group)
    endif
endfunction

command! NoShowMarks call s:disable()
command! ShowMarks call s:enable()

for sign in s:signs
    execute 'nnoremap m'..sign..' <CMD>silent mark '..sign..' <bar> call <SID>update()<CR>'
endfor

augroup my-marker
    autocmd!
    autocmd BufEnter * call s:update()
augroup END
