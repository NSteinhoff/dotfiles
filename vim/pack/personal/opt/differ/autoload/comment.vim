sign define comment text="" texthl=Error

" We don't want to keep creating new quickfix lists with
" every new comment. Instead, we keep overwriting the same one.
" Create a new quickfix list
call setqflist([], ' ', {'title': '>>> COMMENTS <<<'})
let s:qfid = getqflist({'id': 0}).id

function comment#get(filename, lnum)
    for c in comment#list()
        if s:at(c, a:filename, a:lnum)
            return c
        endif
    endfor
    return {}
endfunction

function comment#list()
    let items = getqflist({'id': s:qfid, 'items': 0}).items
    let comments = []
    for q in items
        call add(comments, s:q_to_c(q))
    endfor
    return comments
endfunction

function comment#write(filename, lnum, lines)
    let this = {'lnum': a:lnum, 'filename': a:filename, 'lines': a:lines}

    let items = []
    for c in comment#list()
        if s:same(this, c)
            continue
        else
            call add(items, s:c_to_q(c))
        endif
    endfor

    if !s:empty(this.lines)
        call add(items, s:c_to_q(this))
    endif

    call setqflist([], 'r', {'id': s:qfid, 'items': items})
    call s:place_signs()
endfunction

function comment#wipe(filename, lnum)
    call comment#write(a:filename, a:lnum, [])
endfunction

function comment#wipeall()
    call setqflist([], 'r', {'id': s:qfid, 'items': []})
    call s:place_signs()
endfunction

function s:q_to_c(q)
    return {'filename': bufname(a:q.bufnr), 'lnum': a:q.lnum, 'lines': split(a:q.text, "\n", 1)}
endfunction

function s:c_to_q(c)
    return {'filename': a:c.filename, 'lnum': a:c.lnum, 'text': join(a:c.lines, "\n")}
endfunction

function s:same(this, that)
    return a:this.filename == a:that.filename && a:this.lnum == a:that.lnum
endfunction

function s:at(c, filename, lnum)
    return a:c.filename == a:filename && a:c.lnum == a:lnum
endfunction

function s:place_signs()
    if !exists('*sign_place')
        return
    endif

    sign unplace * group=comments
    for c in comment#list()
        call sign_place(0, 'comments', 'comment', c.filename, {'lnum': c.lnum})
    endfor
endfunction

function s:empty(lines)
    let nlines = len(a:lines)
    if nlines == 0
        return 1
    elseif nlines == 1
        return a:lines[0] == ''
    else
        return 0
    endif
endfunction
