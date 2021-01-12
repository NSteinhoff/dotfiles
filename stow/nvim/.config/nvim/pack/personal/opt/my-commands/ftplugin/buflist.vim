setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile

function s:buffer2line(buffer)
    let b = a:buffer

    return b.bufnr.(b.changed ? '+' : '').' '.b.name
endfunction

function s:line2name(line)
    return split(a:line)[1]
endfunction

function s:load_buflist()
    let lines = []
    for buffer in getbufinfo({'buflisted': 1})
        if !empty(buffer.name)
            call add(lines, s:buffer2line(buffer))
        endif
    endfor

    %delete
    call append(0, lines)
    $delete
endfunction

function s:set_listed(buf)
    let lines = filter(getbufline(a:buf, 1, '$'), { _, v -> !empty(v) })
    let names = map(lines, { _, v -> s:line2name(v) })

    for buffer in getbufinfo({'buflisted': 1})
        if index(names, buffer.name) == -1
            execute 'bdelete ' . buffer.name
        endif
    endfor
endfunction

nnoremap <buffer> - <CMD>delete<CR>
nnoremap <expr> <buffer> <CR> !empty(getline('.')) ? '<CMD>execute "edit ".<SID>line2name(getline("."))<CR>'
                           \: exists(':Dirvish')   ? '<CMD>Dirvish<CR>'
                           \: '<CMD>bdelete<CR>'

augroup buflist
    autocmd!
    autocmd BufEnter <buffer> call s:load_buflist()
    autocmd TextChanged <buffer> call s:set_listed(str2nr(expand('<abuf>')))
augroup END
