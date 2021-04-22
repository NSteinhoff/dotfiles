if get(g:, 'marker_loaded')|finish|endif
let g:marker_loaded = 1
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
    MarkerPlaceSigns
endfunction

function s:disable()
    let g:marker_enabled = 0
    MarkerClearSigns
endfunction

function s:toggle()
    if get(g:, 'marker_enabled')
        call s:disable()
    else
        call s:enable()
    endif
endfunction

function s:place()
    if get(g:, 'marker_enabled')
        call s:place_signs()
    endif
endfunction

command MarkerDisable call s:disable()
command MarkerEnable call s:enable()
command MarkerToggle call s:toggle()
command MarkerPlaceSigns call s:place()
command MarkerClearSigns call sign_unplace(s:sign_group)

for sign in s:signs
    execute 'nnoremap m'..sign..' <CMD>silent mark '..sign..' <bar> MarkerPlaceSigns<CR>'
endfor

augroup my-marker
    autocmd!
    autocmd BufEnter * MarkerPlaceSigns
augroup END
