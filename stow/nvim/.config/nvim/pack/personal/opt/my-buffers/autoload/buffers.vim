function buffers#scratch(lines)
    if @% ==# 'SCRATCH'|return|endif

    let winids = win_findbuf(bufnr('^SCRATCH$'))
    if !empty(winids)
        call win_gotoid(winids[0])
    else
        new SCRATCH
        setlocal buftype=nofile noswapfile nobuflisted
    endif

    if !empty(a:lines)
        let was_empty = line('$') == 1 && empty(getline(1))
        call append('$', a:lines)
        if was_empty|0delete|endif
    endif

    normal G
endfunction

function buffers#delete(wipe)
    let is_last = len(getbufinfo({'buflisted': 1})) <= 1
    let cmd = is_last ? 'edit .' : 'bprevious'

    if exists('b:dirvish')
        execute 'keepalt '..cmd
    elseif bufname() == 'BUFFERS'
        execute 'keepalt '..cmd
    else
        let bufnr = bufnr()
        execute 'keepalt '..cmd
        execute (a:wipe ? 'bwipe' : 'bdelete')..' '..bufnr
    endif
endfunction

function buffers#alternative()
    if empty(expand('#:t')) || (expand('#') == expand('%'))
        echo "No alternate file."
    elseif empty(filter(getbufinfo({'buflisted': 1}), { _, v -> bufnr('#') == v.bufnr })) && !(s:second_try)
        echo "Alternative file '"..fnamemodify(bufname(bufnr('#')), ':t').."' is not listed. Try again to open anyways."
        let s:second_try = v:true
        autocmd CursorMoved * ++once let s:second_try = v:false
    else
        let s:second_try = v:false
        b #
    endif
endfunction
