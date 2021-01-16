setlocal buftype=nofile bufhidden=unload nobuflisted noswapfile

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


function s:exit()
    if !empty(getline('.'))
        execute "edit ".s:line2name(getline("."))
    else
        edit .
    endif
endfunction

nnoremap <buffer> - <CMD>delete<CR>
nnoremap <buffer> <SPACE> <CMD>call <SID>exit()<CR>
nnoremap <buffer> <CR> <CMD>call <SID>exit()<CR>

augroup buflist
    autocmd!
    autocmd BufEnter <buffer> call s:load_buflist()
    autocmd TextChanged <buffer> call s:set_listed(str2nr(expand('<abuf>')))
augroup END
