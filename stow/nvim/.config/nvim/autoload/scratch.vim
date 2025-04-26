let s:bufname = 'scratch://SCRATCH'
let s:global_scratch_file = expand("~/.local/scratch")
let s:local_scratch_file = expand(".scratch")

function s:getfile()
    if filereadable(s:local_scratch_file)
        return s:local_scratch_file
    endif

    return s:global_scratch_file
endfunction

function scratch#init()
    let filename = s:getfile()
    if !filereadable(filename)
        return
    endif

    let buf = bufnr(s:bufname)
    if buf == -1
        return
    endif
    call deletebufline(buf, 1, '$')

    let lines = readfile(filename)
    call appendbufline(buf, '$', lines)
    call deletebufline(buf, 1)
endfunction

function scratch#write() 
    let filename = s:getfile()
    let buf = bufnr(s:bufname)
    let lines = getbufline(buf, 1, '$')
    call writefile(lines, filename)
endfunction

function scratch#toggle(mods)
    let b = s:bufname
    if (bufname() == b)|hide|return|endif
    let winnr = bufwinnr(bufnr(b))
    if winnr == -1
        execute a:mods..' split +set\ nobuflisted\ buftype=nofile\ bufhidden=hide\ noswapfile '..b
        setlocal winfixbuf
        setlocal nospell
        setlocal path-=.
        nnoremap <buffer> <Leader>r mz:read !
        nnoremap <buffer> <Leader><Leader> <Cmd>%delete<CR>
    else
        execute winnr .. 'wincmd w'
    endif
endfunction
