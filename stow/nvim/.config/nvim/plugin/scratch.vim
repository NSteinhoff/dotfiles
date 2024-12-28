function s:scratch(mods)
    let b = 'scratch://SCRATCH'
    if (bufname() == b)|hide|return|endif
    let winnr = bufwinnr(bufnr(b))
    if winnr == -1
        execute a:mods..' split +set\ nobuflisted\ buftype=nofile\ bufhidden=hide\ noswapfile '..b
        setlocal winfixbuf
        setlocal nospell
        setlocal path-=.
        nnoremap <buffer> <Leader>r mz:read !
        nnoremap <buffer> <Leader><Leader> <Cmd>%d<CR>
    else
        execute winnr .. 'wincmd w'
    endif
endfunction

command! -bar Scratch call s:scratch('<mods>')
