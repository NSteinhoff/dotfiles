let s:sign_name = 'qf-mark'
let s:sign_group = 'qf-selected'
call sign_define(s:sign_name, {'text': '>', 'texthl': 'Error'})

augroup QfPreviewCul|augroup END

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

function s:next()
    let list = s:get({'idx': 1, 'size': 1})
    if list.size == 0|return|endif
    let [advance, wrap] = ['next', 'first']
    return (qf#isloc() ? 'l' : 'c')..(list.idx == list.size ? wrap : advance)
endfunction

function s:prev()
    let list = s:get({'idx': 1, 'size': 1})
    if list.size == 0|return|endif
    let [advance, wrap] = ['prev', 'last']
    return (qf#isloc() ? 'l' : 'c')..(list.idx == 1 ? wrap : advance)
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
    call qf#clear_marks()
    if empty(items)|return|endif
    let this = s:get({'title': 1, 'nr': 0})
    let title = '*'..this.title
    call s:set([], ' ', {'title': title, 'items': items, 'nr': (a:0 && a:1 ? '$' : 0)})
endfunction

function qf#swap(v) abort
    let items = a:v ? s:unselected() : s:selected()
    call qf#clear_marks()
    if empty(items)|return|endif
    let this = s:get({'title': 1})
    call s:set([], 'r', {'title': this.title, 'items': items})
endfunction

function qf#add() abort range
    let this = s:get({'title': 1, 'items': 1})
    let items = this.items
    " This might be the first list, so give it a title
    let title = empty(this.title) ? 'Bookmarks' : this.title
    let lnum = a:firstline
    while lnum <= a:lastline
        let item = {'bufnr': bufnr(), 'lnum': lnum, 'col': 1, 'text': getline(lnum)}
        let items = add(items, item)
        let lnum += 1
    endwhile
    call setqflist([], 'r', {'title': title, 'items': items})
endfunction

function qf#new(...) abort
    let title = a:0 && !empty(a:1) ? a:1 : 'Bookmarks'
    call setqflist([], ' ', {'title': title, 'nr': (a:0 >= 2 && a:2 ? 0 : '$')})
endfunction

function qf#duplicate() abort
    let this = s:get({'title': 1, 'items': 1})
    call s:set([], ' ', {'title': this.title, 'items': this.items, 'nr': '$'})
endfunction

function qf#preview(pos)
    let pref = qf#isloc() ? 'l' : 'c'
    let cmd = a:pos == 0 ? line('.')..pref..pref
          \ : a:pos > 0 ? s:next()
          \ : s:prev()
    execute cmd
    let cul = &cursorline ? 'cursorline' : 'nocursorline'
    if !exists('#QfPreviewCul#BufEnter#<buffer>')
        set cursorline
        execute 'autocmd QfPreviewCul BufEnter <buffer> set '..cul..' | autocmd! QfPreviewCul BufEnter <buffer>'
    endif
    wincmd p
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

function qf#cycle_loc(forward) abort
    let loclist = getloclist(0, {'idx': 1, 'size': 1})
    if loclist.size == 0
        echo "No errors."
        return
    endif
    let [advance, wrap] = a:forward ? ['lnext', 'lfirst'] : ['lprevious', 'llast']
    let at_end = a:forward ? loclist.idx == loclist.size : loclist.idx == 1
    execute at_end ? wrap : advance
endfunction

function qf#cycle_qf(forward) abort
    let qflist = getqflist({'idx': 1, 'size': 1})
    if qflist.size == 0
        echo "No errors."
        return
    endif
    let [advance, wrap] = a:forward ? ['cnext', 'cfirst'] : ['cprevious', 'clast']
    let at_end = a:forward ? qflist.idx == qflist.size : qflist.idx == 1
    execute at_end ? wrap : advance
endfunction
