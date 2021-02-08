setlocal buftype=nofile nobuflisted noswapfile

setlocal errorformat=%f:%l:%c:E%n:%m
setlocal errorformat+=%f:%l:%c:%m
setlocal errorformat+=%f:%l:%m
setlocal errorformat+=%f:%l:

function s:item2line(item)
    let fname = bufname(a:item.bufnr)
    let lnum = a:item.lnum
    let col = a:item.col
    let nr = a:item.nr
    let text = a:item.text

    return fname..':'..lnum..':'..(col >= 1 ? col..':' : '')..(nr >= 0 ? 'E'..nr : '')..text
endfunction

function s:load()
    %delete
    let qf = getqflist({'nr': 0, 'items': 1})

    if empty(qf.items)
        return
    endif

    let lines = map(qf.items, { _, v -> s:item2line(v) })

    call append('$', lines)
    1delete
endfunction

function s:export()
    let lines = filter(getbufline('%', 1, '$'), { _, v -> !empty(v) })

    call setqflist([], 'r', {'lines': lines})
endfunction

function s:apply()
    let items = getqflist({'nr': 0, 'items': 1}).items
    for item in items
        " Make sure that the buffer is loaded,
        " else no lines will be returned by getbufline().
        execute ':buffer '..item.bufnr
        let line = getbufline(item.bufnr, item.lnum)[0]
        if line !=# item.text
            call setbufline(item.bufnr, item.lnum, item.text)
        endif
    endfor
endfunction

command -buffer Apply call s:apply()

autocmd BufEnter <buffer> noautocmd call s:load()
autocmd TextChanged <buffer> call s:export()
autocmd InsertLeave <buffer> call s:export()

nnoremap <buffer> <BS> <CMD>keepalt b#<CR>
nnoremap <buffer> <CR> <CMD>execute 'keepalt cc '.line('.')<CR>
nnoremap <buffer> X <CMD>Apply<CR>
