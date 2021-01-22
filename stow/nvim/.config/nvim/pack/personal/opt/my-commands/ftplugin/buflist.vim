setlocal buftype=nofile bufhidden=unload nobuflisted noswapfile

let s:indent = 8

function s:is_arg(fname)
    let i = 0
    while i < argc()
        let a = fnamemodify(argv(i), ':p')
        let b = fnamemodify(a:fname, ':p')
        if a == b
            return 1
        endif
        let i += 1
    endwhile
    return 0
endfunction

function s:buffer2line(buffer, alt)
    let b = a:buffer
    let a = a:alt

    let mods = (s:is_arg(b.name) ? '!' : '').(b == a ? '#' : '').(b.changed ? '+' : '')
    let pref = b.bufnr.(empty(mods) ? '' : ' '.mods)
    let sep = repeat(' ', max([s:indent - strchars(pref), 1]))

    return pref.sep.b.name
endfunction

function s:line2name(line)
    return split(a:line)[-1]
endfunction

function s:load_buflist()
    call deletebufline('', 1, '$')

    let lines = []
    let alt = get(getbufinfo('#'), 0)
    let cursorline = 1

    for buffer in getbufinfo({'buflisted': 1})
        if !empty(buffer.name)
            call add(lines, s:buffer2line(buffer, alt))
            if buffer == alt
                let cursorline = len(lines)
            endif
        endif
    endfor

    call deletebufline('', 0, '$')
    call append(0, lines)
    call deletebufline('', '$', '$')

    call cursor(cursorline, 1)
endfunction

function s:set_listed(buf)
    let lines = filter(getbufline(a:buf, 1, '$'), { _, v -> !empty(v) })
    let names = map(lines, { _, v -> s:line2name(v) })

    for buffer in getbufinfo({'buflisted': 1})
        if index(names, buffer.name) == -1
            execute 'bdelete ' . buffer.name
        endif
    endfor
endfunction


function s:exit(line)
    if empty(a:line)
        keepalt edit .
    else
        execute "keepalt edit ".s:line2name(a:line)
    endif
endfunction

nnoremap <buffer> x <CMD>delete<CR>
nnoremap <buffer> <SPACE> <CMD>call <SID>exit(getline('.'))<CR>
nnoremap <buffer> <CR> <CMD>call <SID>exit(getline('.'))<CR>
nnoremap <buffer> <BS> <CMD>keepalt b#<CR>

augroup buflist
    autocmd!
    autocmd BufEnter <buffer> call s:load_buflist()
    autocmd TextChanged <buffer> call s:set_listed(str2nr(expand('<abuf>')))
augroup END
