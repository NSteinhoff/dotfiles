function s:scratch(lines)
    if @% ==# 'SCRATCH'|return|endif

    let winids = win_findbuf(bufnr('SCRATCH'))
    if !empty(winids)
        call win_gotoid(winids[0])
    else
        new SCRATCH
        setlocal buftype=nofile noswapfile nobuflisted
    endif

    if !empty(a:lines)
        let empty = line('$') == 1 && empty(getline(1))
        call append('$', a:lines)
        if empty|0delete|endif
    endif

    normal G
endfunction
command! -range Scratch call s:scratch(<range> ? getline(<line1>, <line2>) : [])

function s:is_last_buffer()
    return len(getbufinfo({'buflisted': 1})) <= 1
endfunction

function s:go_home(wipe)
    return exists('b:dirvish') ? 'edit .' : 'edit . | '.(a:wipe ? 'bwipe' : 'bdelete').' #'
endfunction

function s:delete_buffer(wipe)
    return exists('b:dirvish') ? 'bprevious' : 'bprevious | '.(a:wipe ? 'bwipe' : 'bdelete').' #'
endfunction

" Delete current buffer
command! Bdelete execute s:is_last_buffer() ? s:go_home(0) : s:delete_buffer(0)
command! Bwipe execute s:is_last_buffer() ? s:go_home(1) : s:delete_buffer(1)

" Delete all but the current buffer
command! -bang Bonly %bd<bang>|e#|bd#

" Open editable buffer list
command! Buffers execute &ft == 'qf' || <q-mods> =~ 'tab' ? 'tabedit BUFFERS' : 'edit BUFFERS'

nnoremap <silent> <plug>(buffers-edit-list) <cmd>Buffers<cr>
nnoremap <silent> <plug>(buffers-delete) <cmd>Bdelete<cr>
nnoremap <silent> <plug>(buffers-wipe) <cmd>Bwipe<cr>
nnoremap <silent> <plug>(buffers-only) <cmd>Bonly<cr>
nnoremap <silent> <plug>(buffers-scratch) <cmd>Scratch<cr>
vnoremap <silent> <plug>(buffers-scratch) :Scratch<cr>
