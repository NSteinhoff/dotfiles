let s:sign_name = 'qf-mark'
let s:sign_group = 'qf-selected'
call sign_define(s:sign_name, {'text': '*', 'texthl': 'Special'})

function qf#isloc()
    return getwininfo(win_getid())[0].loclist == 1
endfunction

function qf#set(...)
    if qf#isloc()
        return call('setloclist', [0] + a:000)
    else
        return call('setqflist', a:000)
    endif
endfunction

function qf#get(...)
    if qf#isloc()
        return call('getloclist', [0] + a:000)
    else
        return call('getqflist', a:000)
    endif
endfunction

function qf#mark()
    let lnum = line('.')
    if index(qf#marked(), lnum) == -1
        call sign_place(lnum, s:sign_group, s:sign_name, "", {'lnum': lnum})
    else
        call sign_unplace(s:sign_group, {'buffer': '', 'id': lnum})
    endif
endfunction

function qf#clear_marks()
    call sign_unplace(s:sign_group)
endfunction

function qf#marked()
    let signs = sign_getplaced("", {'group': s:sign_group})[0].signs
    return map(signs, { _, v -> v.lnum })
endfunction

function qf#selected()
    let lnums = qf#marked()
    let all = qf#get()
    return filter(all, { i, _ -> index(lnums, i + 1) != -1})
endfunction

function qf#unselected()
    let lnums = qf#marked()
    let all = qf#get()
    return filter(all, { i, _ -> index(lnums, i + 1) == -1})
endfunction

function qf#filter(v, ...) abort
    let items = a:v ? qf#unselected() : qf#selected()
    if empty(items)|return|endif
    let title = '*'..qf#get({'title': 1}).title
    call qf#clear_marks()
    call qf#set([], ' ', {'title': title, 'items': items, 'nr': (a:0 && a:1 ? '$' : 0)})
endfunction

function qf#duplicate() abort
    let this = qf#get({'title': 1, 'items': 1})
    call qf#set([], ' ', {'title': this.title, 'items': this.items, 'nr': '$'})
endfunction

function qf#only() abort
    let this = qf#get({'title': 1, 'items': 1})
    call qf#set([], 'f')
    call qf#set([], ' ', {'title': this.title, 'items': this.items, 'nr': '$'})
endfunction

function qf#cycle_lists(forward)
    let curr = qf#get({'nr': 0}).nr
    let last = qf#get({'nr': '$'}).nr
    if last == 1 | return | endif
    let rewind = last - 1

    let prefix = qf#isloc() ? 'l' : 'c'
    let step = a:forward ? (curr == last ? 'older'..rewind : 'newer')
                       \ : (curr == 1    ? 'newer'..rewind : 'older')

    execute prefix..step
endfunction
