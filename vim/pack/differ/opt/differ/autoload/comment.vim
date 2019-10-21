sign define comment text=?? texthl=Error

" We don't want to keep creating new quickfix lists with
" every new comment. Instead, we keep overwriting the same one.
" Create a new quickfix list
call setqflist([], ' ', {'title': 'Diff Comments'})
let s:qfid = getqflist({'id': 0}).id

let s:comments = {}

function! s:place_signs()
    sign unplace * group=comments
    for c in comment#list()
        call sign_place(0, 'comments', 'comment', c.filename, {'lnum': c.lnum})
    endfor
endfunction

function! s:is_empty(comment)
    let nlines = len(a:comment.lines)
    if nlines == 0
        return 1
    elseif nlines == 1
        return a:comment.lines[0] == ''
    else
        return 0
    endif
endfunction

function! s:set_quickfix_comments()
    let items = []
    for c in comment#list()
        call add(items, {'filename': c.filename, 'lnum': c.lnum, 'text': join(c.lines, "\n")})
    endfor
    call setqflist([], 'r', {'id': s:qfid, 'items': items})
endfunction

function! s:refresh()
    if exists('*sign_place')
        call s:place_signs()
    endif
    call s:set_quickfix_comments()
endfunction

" ---------------------------------------------

function! comment#get(filename, lnum)
    return get(get(s:comments, a:filename, {}), a:lnum, {})
endfunction

function! comment#write(filename, lnum, lines)
    let c = {'lnum': a:lnum, 'filename': a:filename, 'lines': a:lines}
    if !has_key(s:comments, c.filename)
        let s:comments[c.filename] = {}
    endif

    if s:is_empty(c)
        if has_key(s:comments[c.filename], c.lnum)
            unlet s:comments[c.filename][c.lnum]
        endif
    else
        let s:comments[c.filename][c.lnum] = c
    endif

    call s:refresh()
endfunction

function! comment#wipe()
    let s:comments = {}
    call s:refresh()
endfunction

function! comment#list()
    let comments = []
    for [fname, lnums] in items(s:comments)
        for [lnum, comment] in items(lnums)
            call add(comments, comment)
        endfor
    endfor
    return comments
endfunction
