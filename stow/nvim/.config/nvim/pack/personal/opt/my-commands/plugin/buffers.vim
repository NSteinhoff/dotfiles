let s:last_failed = 'NONE'

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
    if exists('b:dirvish')
        keepalt edit .
    elseif bufname() == 'BUFFERS'
        keepalt edit .
    else
        let bufnr = bufnr()
        keepalt edit .
        execute (a:wipe ? 'bwipe' : 'bdelete')..' '..bufnr
    endif
endfunction

function s:delete_buffer(wipe)
    if exists('b:dirvish')
        keepalt bprevious
    elseif bufname() == 'BUFFERS'
        keepalt bprevious
    else
        let bufnr = bufnr()
        keepalt bprevious
        execute (a:wipe ? 'bwipe' : 'bdelete')..' '..bufnr
    endif
endfunction

function s:alternative()
    if empty(expand('#:t')) || (expand('#') == expand('%'))
        echo "No alternate file."
    elseif empty(filter(getbufinfo({'buflisted': 1}), { _, v -> bufnr('#') == v.bufnr })) && !(s:last_failed == bufnr('%'))
        echo "Alternative file <b"..bufnr('#').."> is not listed. Try again to open anyways."
        let s:last_failed = bufnr('%')
    else
        let s:last_failed = 'NONE'
        b #
    endif
endfunction
command! Balternative call s:alternative()

" Delete current buffer
command! Bdelete if s:is_last_buffer() | call s:go_home(0) | else | call s:delete_buffer(0) | endif
command! Bwipe if s:is_last_buffer() | call s:go_home(1) | else | call s:delete_buffer(1) | endif

" Delete all but the current buffer
command! -bang Bonly %bd<bang>|e#|bd#

" Open editable buffer list
command! Buffers execute &ft == 'qf' || <q-mods> =~ 'tab' ? 'tabedit BUFFERS' : 'edit BUFFERS'

" Open new buffers with same filetype
command! -nargs=? -complete=buffer Bnew let ft = &ft | new <args> | let &ft=ft
command! -nargs=? -complete=buffer Bvnew let ft = &ft | vnew <args> | let &ft=ft

nnoremap <silent> <plug>(buffers-edit-list) <cmd>Buffers<cr>
nnoremap <silent> <plug>(buffers-delete) <cmd>Bdelete<cr>
nnoremap <silent> <plug>(buffers-wipe) <cmd>Bwipe<cr>
nnoremap <silent> <plug>(buffers-only) <cmd>Bonly<cr>
nnoremap <silent> <plug>(buffers-scratch) <cmd>Scratch<cr>
vnoremap <silent> <plug>(buffers-scratch) :Scratch<cr>
nnoremap <silent> <plug>(buffers-new) <cmd>Bnew<cr>
nnoremap <silent> <plug>(buffers-vnew) <cmd>Bvnew<cr>
nnoremap <silent> <plug>(buffers-alternative) <cmd>Balternative<cr>
