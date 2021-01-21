set buftype=nofile bufhidden=unload nobuflisted noswapfile

setlocal errorformat=%f:%l:%c:\ (%n)\ %m
setlocal errorformat+=%f:%l:%c:\ %m
setlocal errorformat+=%f:%l:\ %m
setlocal errorformat+=%f:%l:

function s:item2line(item)
    let fname = bufname(a:item.bufnr)
    let lnum = a:item.lnum
    let col = a:item.col
    let nr = a:item.nr
    let text = a:item.text

    return fname.':'.lnum.':'.(col >= 1 ? col.':' : '').(nr >= 0 ? ' ('.nr.')' : '').(' '.text)
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

autocmd BufEnter <buffer> noautocmd call s:load()
autocmd TextChanged <buffer> call s:export()

nnoremap <buffer> <BS> <CMD>keepalt b#<CR>
nnoremap <buffer> <CR> <CMD>execute 'cc '.line('.')<CR>
