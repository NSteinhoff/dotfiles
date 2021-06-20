let s:sign_name = 'qf-mark'
let s:clipboard = {}

call sign_define(s:sign_name, {'text': '>', 'texthl': 'Error'})

" Create the autocmd group for previewing errors
augroup QfPreviewCul|augroup END

function qf#isqf()
    return getwininfo(win_getid())[0].quickfix == 1
endfunction

function qf#isloc()
    return qf#isqf() && getwininfo(win_getid())[0].loclist == 1
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

function s:sign_group()
    return 'qf-selected-'..(qf#isloc() ? 'loc' : 'qf')
endfunction

function s:marked()
    let signs = sign_getplaced("", {'group': s:sign_group()})[0].signs
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
    let list = s:get({'idx': 0, 'size': 1})
    if list.size == 0|return|endif
    let [advance, wrap] = ['next', 'first']
    return (qf#isloc() ? 'l' : 'c')..(list.idx == list.size ? wrap : advance)
endfunction

function s:prev()
    let list = s:get({'idx': 0, 'size': 1})
    if list.size == 0|return|endif
    let [advance, wrap] = ['prev', 'last']
    return (qf#isloc() ? 'l' : 'c')..(list.idx == 1 ? wrap : advance)
endfunction

function s:setmany(lists)
    for list in a:lists
        let list.nr = '$'
        call s:set([], ' ', list)
    endfor
endfunction

function s:lists()
    let lists = []
    let nlists = s:get({'nr': '$'}).nr
    let idx = 1
    while idx <= nlists
        call add(lists, s:get({'all': 1, 'nr': idx}))
        let idx += 1
    endwhile
    return lists
endfunction

function s:goto(nr)
    let curr = s:get({'nr': 0}).nr
    if curr == 0|return|endif

    let last = s:get({'nr': '$'}).nr
    let target = a:nr == '$' ? last : max([1, min([last, a:nr])])
    let steps = target - curr
    if steps == 0
        return
    elseif steps > 0
        execute steps..(qf#isloc() ? 'l' : 'c')..'newer'
    else
        execute -steps..(qf#isloc() ? 'l' : 'c')..'older'
    endif
endfunction

function qf#mark()
    if !qf#isqf()|return|endif

    let lnum = line('.')
    if index(s:marked(), lnum) == -1
        call sign_place(lnum, s:sign_group(), s:sign_name, "", {'lnum': lnum})
    else
        call sign_unplace(s:sign_group(), {'buffer': '', 'id': lnum})
    endif
endfunction

function qf#clear_marks()
    if !qf#isqf()|return|endif

    call sign_unplace(s:sign_group())
endfunction

function qf#filter(v, ...) abort
    if !qf#isqf()|return|endif

    let items = a:v ? s:unselected() : s:selected()
    call qf#clear_marks()
    if empty(items)|return|endif
    let this = s:get({'all': 1})
    let this.title = '*'..this.title
    let this.items = items
    let this.nr = (a:0 && a:1 ? '$' : 0)
    call s:set([], ' ', this)
endfunction

function qf#swap(v) abort
    if !qf#isqf()|return|endif

    let items = a:v ? s:unselected() : s:selected()
    call qf#clear_marks()
    if empty(items)|return|endif
    let this = s:get({'all': 1})
    let this.items = items
    call s:set([], 'r', this)
endfunction

function qf#preview(pos)
    if !qf#isqf()|return|endif

    let pref = qf#isloc() ? 'll' : 'cc'
    let cmd = a:pos == 0 ? line('.')..pref
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

function qf#cycle_lists(forward)
    if !qf#isqf()|return|endif

    let curr = s:get({'nr': 0}).nr
    let last = s:get({'nr': '$'}).nr
    if last == 1 | return | endif
    let rewind = last - 1

    let prefix = qf#isloc() ? 'l' : 'c'
    let step = a:forward ? (curr == last ? 'older'..rewind : 'newer')
                       \ : (curr == 1    ? 'newer'..rewind : 'older')

    execute prefix..step
endfunction

function qf#yank() abort
    if !qf#isqf()|return|endif

    let this = s:get({'all': 1})
    let s:clipboard = this
    echo this.size.." errors yanked."
endfunction

function qf#delete() abort
    if !qf#isqf()|return|endif

    let lists = s:lists()
    let this = s:get({'all': 1})
    call filter(lists, {_, l -> l.nr != this.nr})
    let s:clipboard = copy(this)
    call s:set([], 'f')
    call s:setmany(lists)
    call s:goto(this.nr)
endfunction

function qf#paste() abort
    if !qf#isqf()|return|endif

    let lists = s:lists()
    if empty(s:clipboard)
        echom "Quickfix list clipboard empty."
    else
        let nr = s:get({'nr': 0}).nr
        call insert(lists, s:clipboard, nr)
        call s:set([], 'f')
        call s:setmany(lists)
        call s:goto(nr + 1)
    endif
endfunction

function qf#only() abort
    if !qf#isqf()|return|endif

    let this = s:get({'all': 1})
    let this.nr = '$'
    call s:set([], 'f')
    call s:set([], ' ', this)
endfunction


" -------------------------------------------------------------------------- "
"                                   Global                                   "
" -------------------------------------------------------------------------- "
function qf#new(...) abort
    let title = a:0 && !empty(a:1) ? a:1 : 'Bookmarks'
    call setqflist([], ' ', {'title': title, 'nr': (a:0 >= 2 && a:2 ? 0 : '$')})
endfunction

function qf#add() abort range
    let this = getqflist({'all': 1})
    let this.title = empty(this.title) ? 'Bookmarks' : this.title
    let lnum = a:firstline
    while lnum <= a:lastline
        let item = {'bufnr': bufnr(), 'lnum': lnum, 'col': 1, 'text': getline(lnum)}
        call add(this.items, item)
        let lnum += 1
    endwhile
    call setqflist([], this.nr == 0 ? ' ' : 'r', this)
endfunction

function qf#cycle_loc(forward) abort
    let loclist = getloclist(0, {'idx': 0, 'size': 1})
    if loclist.size == 0
        echo "No errors."
        return
    endif
    let [advance, wrap] = a:forward ? ['lnext', 'lfirst'] : ['lprevious', 'llast']
    let at_end = a:forward ? loclist.idx == loclist.size : loclist.idx == 1
    execute at_end ? wrap : advance
endfunction

function qf#cycle_qf(forward) abort
    let qflist = getqflist({'idx': 0, 'size': 1})
    if qflist.size == 0
        echo "No errors."
        return
    endif
    let [advance, wrap] = a:forward ? ['cnext', 'cfirst'] : ['cprevious', 'clast']
    let at_end = a:forward ? qflist.idx == qflist.size : qflist.idx == 1
    execute at_end ? wrap : advance
endfunction

" -------------------------------------------------------------------------- "
"                         Quickfixtextfunc Callbacks                         "
" -------------------------------------------------------------------------- "
function qf#text_only(info)
    let items = s:get({'id' : a:info.id, 'items' : 1}).items
    let lines = []
    for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
      call add(lines, items[idx].text)
    endfor
    return lines
endfunc

function qf#no_bufnames(info)
    let items = s:get({'id' : a:info.id, 'items' : 1}).items
    let lines = []
    for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
        let item = items[idx]
        let line = '|'..item.lnum
        let line .= item.col ? ' col '..item.col : ''
        let line .= item.nr != -1 && !empty(item.type) ? ' '..item.type..' '..item.nr : ''
        let line .= '|'..item.text
        call add(lines, line)
    endfor
    return lines
endfunc

function qf#bufnames(info)
    let items = s:get({'id' : a:info.id, 'items' : 1}).items
    let lines = []
    for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
        " use the simplified file name
        call add(lines, fnamemodify(bufname(items[idx].bufnr), ':p:.'))
    endfor
    return lines
endfunc
