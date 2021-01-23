command! -bang BufOnly %bd<bang>|e#|bd#

function s:scratch(ft, mods)
    let ft = a:ft != '' ? a:ft : &ft
    execute a:mods =~ 'vertical' ? 'vnew' : 'new'
    let &ft = ft
    setlocal buftype=nofile bufhidden=hide noswapfile
endfunction
command! -nargs=? -complete=filetype Scratch call s:scratch(<q-args>, '<mods>')

" Delete current buffer
command! Bdelete execute len(getbufinfo({'buflisted': 1})) > 1 && !empty(getreg('#'))
            \? exists('b:dirvish') ? 'bprevious' : 'bprevious | bdelete #'
            \: exists('b:dirvish') ? 'edit .' : 'edit . | bdelete#'

" Open editable buffer list
command! BufList execute &ft == 'qf' ? 'new buflist' : 'edit buflist'

nnoremap <silent> <Plug>(buffers-edit-list) <CMD>BufList<CR>
nnoremap <silent> <Plug>(buffers-delete) <CMD>Bdelete<CR>
nnoremap <silent> <Plug>(buffers-only) <CMD>BufOnly<CR>
