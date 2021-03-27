command! -bang BufOnly %bd<bang>|e#|bd#

function s:scratch(mods, lines)
    if @% ==# 'SCRATCH'|return|endif
    execute a:mods..' '..(&ft == 'qf' ? 'new' : 'edit')..' SCRATCH'
    setlocal buftype=nofile noswapfile nobuflisted
    call append('$', a:lines)
endfunction
command! -range -complete=filetype Scratch call s:scratch(<q-mods>, <range> ? getline(<line1>, <line2>) : [])

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

" Open editable buffer list
command! BufList execute &ft == 'qf' ? 'new BUFFERS' : 'edit BUFFERS'

nnoremap <silent> <Plug>(buffers-edit-list) <CMD>BufList<CR>
nnoremap <silent> <Plug>(buffers-delete) <CMD>Bdelete<CR>
nnoremap <silent> <Plug>(buffers-wipe) <CMD>Bwipe<CR>
nnoremap <silent> <Plug>(buffers-only) <CMD>BufOnly<CR>
