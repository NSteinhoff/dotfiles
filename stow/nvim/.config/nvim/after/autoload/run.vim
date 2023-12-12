function run#interpret(buf, line1, line2, ...)
    let cmd = getbufvar(a:buf, 'interpreter')
    if empty(cmd)
        echom 'Interpreter not set. Set b:interpreter for this buffer.'
        return
    endif
    let range = printf("%d,%d", a:line1, a:line2)
    execute printf("%sw !%s %s", range, cmd, a:0 > 0 ? ' '..a:000->join(' ') : '')
endfunction

function run#update_buf(buf, ...)
    let cmd = getbufvar(a:buf, 'interpreter')
    if empty(cmd)
        echom 'Interpreter not set. Set b:interpreter for this buffer.'
        return
    endif

    if a:0 > 0
        let cmd .= ' '..a:000->join(' ')
    endif

    let target_buf = "run://"..bufname(a:buf)
    if !bufexists(target_buf)
        call bufadd(target_buf)
        call bufload(target_buf)
        call setbufvar(target_buf, "&buftype", "nofile")
        call setbufvar(target_buf, "&swapfile", 0)
        call setbufvar(target_buf, "&bufhidden", "wipe")
    endif

    let winnr = bufwinnr(bufnr(target_buf))
    if winnr == -1
        execute 'rightbelow 10 split '..target_buf
        wincmd p
    endif

    let input = getbufline(a:buf, 1, "$") + [""]
    let output = systemlist(cmd, input)

    call deletebufline(target_buf, 1, "$")
    call appendbufline(target_buf, 0, output)
endfunction

function run#update_qf(buf, ...)
    let cmd = getbufvar(a:buf, 'interpreter')
    if empty(cmd)
        echom 'Interpreter not set. Set b:interpreter for this buffer.'
        return
    endif

    if a:0 > 0
        let cmd .= ' '..a:000->join(' ')
    endif
    let cmd .= ' 2>&1'

    let input = getbufline(a:buf, 1, "$") + [""]
    let output = systemlist(cmd, input)

    call setqflist([], ' ', {
                \'lines': output,
                \'efm': '%m',
                \'title': printf('Run: %s %s', bufname(a:buf), strftime("%T")),
                \})
    if len(output)
        execute "botright copen"..min([len(output), 10])
    endif
endfunction

function run#prime(bang, list)
    if exists("#run#BufWritePost#<buffer>")
        autocmd! run BufWritePost <buffer>
    endif
    if a:bang
        echo "Stop live executing "..bufname()
    else
        echo "Live executing "..bufname()
        augroup run
            if a:list == 'b'
                autocmd BufWritePost <buffer> call run#update_buf(str2nr(expand("<abuf>")))
            else
                autocmd BufWritePost <buffer> call run#update_qf(str2nr(expand("<abuf>")))
            endif
        augroup END
    endif
endfunction
