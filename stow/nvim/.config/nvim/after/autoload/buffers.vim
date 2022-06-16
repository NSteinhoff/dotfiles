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
