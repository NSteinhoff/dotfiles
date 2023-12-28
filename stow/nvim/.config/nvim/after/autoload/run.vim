function run#interpret(buf, line1, line2, ...)
    let cmd = getbufvar(a:buf, 'interpreter')
    if empty(cmd)
        echom 'Interpreter not set. Set b:interpreter for this buffer.'
        return
    endif
    let range = printf("%d,%d", a:line1, a:line2)
    execute printf("%sw !%s %s", range, cmd, a:0 > 0 ? ' '..a:000->join(' ') : '')
endfunction

function s:get_output_lines(buf)
    let cmd = getbufvar(a:buf, 'interpreter')
    if empty(cmd)
        echom 'Interpreter not set. Set b:interpreter for this buffer.'
        return
    endif
    let cmd .= ' 2>&1'

    let input = getbufline(a:buf, 1, "$") + [""]
    let output = systemlist(cmd, input)

    return output
endfunction

function s:update_buf(buf, lines)
    let target_buf = "run://"..bufname(a:buf)
    if !bufexists(target_buf)
        call bufadd(target_buf)
        call bufload(target_buf)
        call setbufvar(target_buf, "&buftype", "nofile")
        call setbufvar(target_buf, "&swapfile", 0)
        call setbufvar(target_buf, "&bufhidden", "wipe")
    endif

    call deletebufline(target_buf, 1, "$")
    call appendbufline(target_buf, 0, a:lines)
    call deletebufline(target_buf, "$")

    let winnr = bufwinnr(bufnr(target_buf))
    if winnr == -1
        execute 'rightbelow 10 split '..target_buf
    else
        execute winnr .. "wincmd w"
    endif
    if winnr() != winnr('j') || winnr() != winnr('k')
        " We are in a horizontal split
        execute "resize " .. min([len(a:lines), 10])
    endif
    normal gg
    normal G
    wincmd p
endfunction

function s:update_qf(buf, lines)
    call setqflist([], ' ', {
                \'lines': a:lines,
                \'efm': '%m',
                \'title': printf('Run: %s %s', bufname(a:buf), strftime("%T")),
                \})
    if len(a:lines)
        execute "botright copen"..min([len(a:lines), 10])
    endif
endfunction

function s:run_on_save(buf, target)
    let UpdateTarget = { lines -> a:target == 'buf' ? s:update_buf(a:buf, lines) : s:update_qf(a:buf, lines) }

    call UpdateTarget([strftime("%T")..": Running! Please wait..."])
    redraw

    let output = s:get_output_lines(a:buf)
    call UpdateTarget(output)
endfunction

function run#prime(bang, target)
    if exists("#run#BufWritePost#<buffer>")
        autocmd! run BufWritePost <buffer>
    endif
    if a:bang
        echo "Stop live executing "..bufname()
    else
        echo "Live executing "..bufname()
        augroup run
            if a:target == 'buf'
                autocmd BufWritePost <buffer> call s:run_on_save(str2nr(expand("<abuf>")), 'buf')
            else
                autocmd BufWritePost <buffer> call s:run_on_save(str2nr(expand("<abuf>")), 'qf')
            endif
        augroup END
    endif
endfunction
