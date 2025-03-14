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

function marks#toggle()
    if s:enabled()
        call marks#disable()
        echo "noshowmarks"
    else
        call marks#enable()
        echo "  showmarks"
    endif
endfunction

function marks#enable()
    if s:enabled()|return|endif
    aug my-showmarks
    au!
    au BufEnter,CursorHold * silent! call s:place_signs()
    aug END
endfunction

function marks#disable()
    if !s:enabled()|return|endif
    au! my-showmarks
    aug! my-showmarks
    call sign_unplace(s:sign_group)
endfunction
