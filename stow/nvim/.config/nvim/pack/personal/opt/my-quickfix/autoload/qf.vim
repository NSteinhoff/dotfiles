let s:sign_name = 'qf-mark'
let s:sign_group = 'qf-selected'
call sign_define(s:sign_name, {'text': '>', 'texthl': 'Error'})

function qf#isloc()
    return getwininfo(win_getid())[0].loclist == 1
endfunction

function s:set(...)
    if qf#isloc()
        return call('setloclist', [0] + a:000)
    else
        return call('setqflist', a:000)
    endif
endfunction

function s:get(...)
    if qf#isloc()
        return call('getloclist', [0] + a:000)
    else
        return call('getqflist', a:000)
    endif
endfunction

function s:marked()
    let signs = sign_getplaced("", {'group': s:sign_group})[0].signs
    return map(signs, { _, v -> v.lnum })
endfunction

function s:selected()
    let lnums = s:marked()
    let all = s:get()
    return filter(all, { i, _ -> index(lnums, i + 1) != -1})
endfunction

function s:unselected()
    let lnums = s:marked()
    let all = s:get()
    return filter(all, { i, _ -> index(lnums, i + 1) == -1})
endfunction

function qf#mark()
    let lnum = line('.')
    if index(s:marked(), lnum) == -1
        call sign_place(lnum, s:sign_group, s:sign_name, "", {'lnum': lnum})
    else
        call sign_unplace(s:sign_group, {'buffer': '', 'id': lnum})
    endif
endfunction

function qf#clear_marks()
    call sign_unplace(s:sign_group)
endfunction

function qf#filter(v, ...) abort
    let items = a:v ? s:unselected() : s:selected()
    if empty(items)|return|endif
    let title = '*'..s:get({'title': 1}).title
    call qf#clear_marks()
    call s:set([], ' ', {'title': title, 'items': items, 'nr': (a:0 && a:1 ? '$' : 0)})
endfunction

function qf#duplicate() abort
    let this = s:get({'title': 1, 'items': 1})
    call s:set([], ' ', {'title': this.title, 'items': this.items, 'nr': '$'})
endfunction

function qf#only() abort
    let this = s:get({'title': 1, 'items': 1})
    call s:set([], 'f')
    call s:set([], ' ', {'title': this.title, 'items': this.items, 'nr': '$'})
endfunction

function qf#cycle_lists(forward)
    let curr = s:get({'nr': 0}).nr
    let last = s:get({'nr': '$'}).nr
    if last == 1 | return | endif
    let rewind = last - 1

    let prefix = qf#isloc() ? 'l' : 'c'
    let step = a:forward ? (curr == last ? 'older'..rewind : 'newer')
                       \ : (curr == 1    ? 'newer'..rewind : 'older')

    execute prefix..step
endfunction
