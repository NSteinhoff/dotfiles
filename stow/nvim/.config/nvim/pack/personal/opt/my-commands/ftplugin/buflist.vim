setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile

function s:set_listed(buf)
    let names = getbufline(a:buf, 1, '$')
    let listed = getbufinfo({'buflisted': 1})
    for buffer in listed
        if index(names, buffer.name) == -1
            execute 'bdelete ' . buffer.name
        endif
    endfor
endfunction

nnoremap <buffer> q <CMD>bdelete<CR>

augroup buflist
    autocmd!
    autocmd BufWipeout <buffer> call s:set_listed(str2nr(expand('<abuf>')))
augroup END
