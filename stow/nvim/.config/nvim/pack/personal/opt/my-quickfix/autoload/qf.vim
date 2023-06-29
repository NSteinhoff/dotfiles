let s:sign_name = 'qf-mark'
let s:clipboard = {}
let s:max_lines = 10

call sign_define(s:sign_name, {'text': '>', 'texthl': 'Error'})

function qf#ltoggle()
    if qf#locvisible()
        lclose
    else
        try
            lopen
        catch /E776: No location list/
            " pass
        endtry
        if qf#isloc()
            wincmd p
        endif
    endif
endfunction

function qf#ctoggle()
    if qf#qfvisible()
        cclose
    else
        botright copen
        if qf#isqf()
            wincmd p
        endif
    endif
endfunction

function qf#locvisible()
    return !empty(filter(getwininfo(), { _, win -> win.tabnr == tabpagenr() && win.quickfix && win.loclist }))
endfunction

function qf#qfvisible()
    return !empty(filter(getwininfo(), { _, win -> win.tabnr == tabpagenr() && win.quickfix && !win.loclist }))
endfunction

function qf#isqf()
    return getwininfo(win_getid())[0].quickfix == 1
endfunction

function qf#isloc()
    return qf#isqf() && getwininfo(win_getid())[0].loclist == 1
endfunction

function qf#cycle_loc(forward) abort
    let list = getloclist(0, {'idx': 0, 'size': 1, 'items': 1})
    let [first, last] = s:first_and_last(list.items)
    if !first|echo "No errors."|return|endif
    if a:forward
        execute list.idx < last ? 'lnext' : first..'ll'
    else
        execute list.idx > first ? 'lprev' : last..'ll'
    endif
endfunction

function qf#cycle_qf(forward) abort
    let list = getqflist({'idx': 0, 'size': 1, 'items': 1})
    let [first, last] = s:first_and_last(list.items)
    if !first|echo "No errors."|return|endif
    if a:forward
        execute list.idx < last ? 'cnext' : first..'cc'
    else
        execute list.idx > first ? 'cprev' : last..'cc'
    endif
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

function s:replace(items)
    let this = s:get({'all': 1})
    let selected = this.items[this.idx - 1]
    let this.items = a:items
    let idx = index(this.items, selected)
    if idx > -1
        let this.idx = idx + 1
    else
        let this.idx = this.idx > len(this.items) ? len(this.items) + 1 : this.idx
    endif
    call s:set([], 'r', this)
endfunction

function s:first_and_last(items) abort
    let items = map(copy(a:items), { i, v -> [i+1, v]})
    let valid = filter(items, { _, v -> v[1].valid })
    let first = get(valid, 0, [0, 0])[0]
    let last = get(valid, -1, [0, 0])[0]
    return [first, last]
endfunction

function s:here() abort
    let list = s:get({'idx': 0, 'size': 1, 'items': 1})
    if list.size == 0|return|endif
    let lnum = line('.')
    let num = list.items[lnum - 1].valid ? lnum : 0
    return num ? num..(qf#isloc() ? 'll' : 'cc') : ''
endfunction

function s:next()
    let list = s:get({'idx': 0, 'size': 1, 'items': 1})
    let [first, last] = s:first_and_last(list.items)
    if !first|return|endif
    let advance = (qf#isloc() ? 'l' : 'c')..'next'
    let wrap = first..(qf#isloc() ? 'll' : 'cc')
    return last > list.idx ? advance : wrap
endfunction

function s:prev()
    let list = s:get({'idx': 0, 'size': 1, 'items': 1})
    let [first, last] = s:first_and_last(list.items)
    if !first|return|endif
    let advance = (qf#isloc() ? 'l' : 'c')..'prev'
    let wrap = last..(qf#isloc() ? 'll' : 'cc')
    return first < list.idx ? advance : wrap
endfunction

function s:setmany(lists)
    for list in a:lists
        let list.nr = '$'
        call s:set([], ' ', list)
    endfor
endfunction

function s:replace_all(lists)
    call s:set([], 'f')
    call s:setmany(a:lists)
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
        execute 'silent '..steps..(qf#isloc() ? 'l' : 'c')..'newer'
    else
        execute 'silent '..-steps..(qf#isloc() ? 'l' : 'c')..'older'
    endif
endfunction

" ---------------------------------- Items -----------------------------------
function qf#mark()
    if !qf#isqf()|return|endif

    let lnum = line('.')
    if index(s:marked(), lnum) == -1
        call sign_place(lnum, s:sign_group(), s:sign_name, "", {'lnum': lnum})
    else
        call sign_unplace(s:sign_group(), {'buffer': '', 'id': lnum})
    endif
endfunction

function qf#delete() range
    if !qf#isqf()|return|endif

    let lnums = range(a:firstline, a:lastline)
    let items = s:get()
    let items = filter(items, { i, _ -> index(lnums, i + 1) == -1})
    call s:replace(items)
    execute min([a:firstline, line('$')])
endfunction

function qf#preview()
    if !qf#isqf()|return|endif

    let item = s:get()[line('.') - 1]
    let lnum = item['lnum']
    let @/='\%'..lnum..'l\S.*$'
    set hlsearch
endfunction

" ---------------------------------- Lists -----------------------------------
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
    call s:replace(items)
endfunction

function s:where_am_i()
    if !qf#isqf()
        return 'not currently in a qf list window'
    endif

    let curr = s:get({'nr': 0}).nr
    let last = s:get({'nr': '$'}).nr

    return 'error list '..curr..' of '..last
endfunction

function qf#cycle_lists(forward)
    if !qf#isqf()|return|endif

    let curr = s:get({'nr': 0}).nr
    let last = s:get({'nr': '$'}).nr

    if last == 1 | echo s:where_am_i() | return | endif
    call qf#clear_marks()

    let rewind = last - 1
    let prefix = qf#isloc() ? 'l' : 'c'
    let step = a:forward ? (curr == last ? 'older'..rewind : 'newer')
                       \ : (curr == 1    ? 'newer'..rewind : 'older')

    execute 'silent '..prefix..step
    echo s:where_am_i()
endfunction

function qf#yank() abort
    if !qf#isqf()|return|endif

    let this = s:get({'all': 1})
    let s:clipboard = this
    echo this.size.." errors yanked."
endfunction

function qf#cut() abort
    if !qf#isqf()|return|endif
    call qf#clear_marks()

    let lists = s:lists()
    let this = s:get({'all': 1})
    call filter(lists, {_, l -> l.nr != this.nr})
    let s:clipboard = copy(this)
    call s:replace_all(lists)
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
        call s:replace_all(lists)
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

function qf#textfunc(info)
    if a:info.quickfix
        let items = getqflist({'id' : a:info.id, 'items' : 1}).items
    else
        let items = getloclist(a:info.winid, {'id' : a:info.id, 'items' : 1}).items
    endif

    let new_items = []
    let max_length = {'file': 0, 'lnum': 0, 'col': 0, 'text': 0}
    for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
        let item = items[idx]

        let file  = fnamemodify(bufname(item.bufnr), ':p:.')
        if get(g:, 'quickfix_pathshorten', 0)
            let file  = pathshorten(file)
        endif
        let lnum  = string(item.lnum)
        let col   = string(item.col)
        let text  = item.text

        let new_item = {}
        let new_item.file  = [file, len(file)]
        let new_item.lnum  = [lnum, len(lnum)]
        let new_item.col   = [col, len(col)]
        let new_item.text  = [text, len(text)]

        for k in ['file', 'lnum', 'col', 'text']
            if new_item[k][1] > max_length[k]
                let max_length[k] = new_item[k][1]
            endif
        endfor

        call add(new_items, new_item)
    endfor

    let display_lines = []
    for item in new_items
        let [file, len_file]  = item.file
        let [lnum, len_lnum]  = item.lnum
        let [col,  len_col]   = item.col
        let [text, len_text]  = item.text

        let s  = file
        let s .= repeat(' ', max_length['file'] - len_file)
        let s .= '|'
        let s .= repeat(' ', max_length['lnum'] - len_lnum)
        let s .= lnum
        let s .= ' col '
        let s .= repeat(' ', max_length['col'] - len_col)
        let s .= col
        let s .= '| '
        let s .= text

        call add(display_lines, s)
    endfor

    return display_lines
endfunction
