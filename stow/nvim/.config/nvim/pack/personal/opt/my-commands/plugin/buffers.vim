command! -bang BufOnly %bd<bang>|e#|bd#

function s:scratch(ft, mods)
    let ft = a:ft != '' ? a:ft : &ft
    execute a:mods =~ 'vertical' ? 'vnew' : 'new'
    let &ft = ft
    setlocal buftype=nofile bufhidden=hide noswapfile
endfunction
command! -nargs=? -complete=filetype Scratch call s:scratch(<q-args>, '<mods>')

function s:is_last_buffer()
    return len(getbufinfo({'buflisted': 1})) == 1 || empty(getreg('#'))
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
command! BufList execute &ft == 'qf' ? 'new buflist' : 'edit buflist'

nnoremap <silent> <Plug>(buffers-edit-list) <CMD>BufList<CR>
nnoremap <silent> <Plug>(buffers-delete) <CMD>Bdelete<CR>
nnoremap <silent> <Plug>(buffers-wipe) <CMD>Bwipe<CR>
nnoremap <silent> <Plug>(buffers-only) <CMD>BufOnly<CR>
