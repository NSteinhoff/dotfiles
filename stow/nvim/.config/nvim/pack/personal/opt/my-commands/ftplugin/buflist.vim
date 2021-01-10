setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile

function s:load_buflist()
    let buffers = getbufinfo({'buflisted': 1})
    let lines = []
    for buffer in buffers
        if buffer.name != ''
            call add(lines, buffer.name)
        endif
    endfor
    %delete
    call append(0, lines)
    $delete
endfunction

function s:set_listed(buf)
    let names = filter(getbufline(a:buf, 1, '$'), { _, v -> !empty(v) })
    let listed = getbufinfo({'buflisted': 1})
    for buffer in listed
        if index(names, buffer.name) == -1
            execute 'bdelete ' . buffer.name
        endif
    endfor
endfunction

nnoremap <buffer> - <CMD>delete<CR>
nnoremap <expr> <buffer> <CR> empty(getline('.')) ? '<CMD>bdelete<CR>' : 'gf'

augroup buflist
    autocmd!
    autocmd BufEnter <buffer> call s:load_buflist()
    autocmd TextChanged <buffer> call s:set_listed(str2nr(expand('<abuf>')))
augroup END
