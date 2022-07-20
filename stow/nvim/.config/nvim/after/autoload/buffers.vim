let s:tried = v:false

function buffers#alternative()
    if empty(expand('#:t')) || (expand('#') == expand('%'))
        echo "No alternate file."
    elseif empty(filter(getbufinfo({'buflisted': 1}), { _, v -> bufnr('#') == v.bufnr })) && !(s:tried)
        echo "Alternative file '"..fnamemodify(bufname(bufnr('#')), ':t').."' is not listed. Try again to open anyways."
        let s:tried = v:true
        autocmd CursorMoved * ++once let s:tried = v:false
    else
        let s:tried = v:false
        b #
    endif
endfunction

function buffers#recent(n = 0)
    let n = a:n
    if n == 0
        let n = min([max([&lines - 10, 10]), 10])
    endif
    echo "Recent Buffers:"
    echo execute('ls t')->split("\n")[:n]->join("\n")
endfunction
