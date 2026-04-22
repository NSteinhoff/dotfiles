let s:tried_alternative = v:false
let s:tried_yang = v:false

function buffers#alternative()
    if empty(expand('#:t')) || (expand('#') == expand('%'))
        echo "No alternate file."
    elseif empty(filter(getbufinfo({'buflisted': 1}), { _, v -> bufnr('#') == v.bufnr })) && !(s:tried_alternative)
        echo "Alternative file '"..fnamemodify(bufname(bufnr('#')), ':t').."' is not listed. Try again to open anyways."
        let s:tried_alternative = v:true
        autocmd CursorMoved * ++once let s:tried_alternative = v:false
    else
        let s:tried_alternative = v:false
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

function! buffers#get_yang()
    let l:current = expand('%')

    if l:current =~ '\.\(c\|h\)$'
        return fnamemodify(l:current, ':r') . (l:current =~ '\.c$' ? '.h' : '.c')
    endif

    if l:current =~ '\.\(js\|jsx\|ts\|tsx\)$'
        return ftutils#javascript#get_alt(l:current)
    endif

    return ''
endfunction

function buffers#yang()
    let l:yang = buffers#get_yang()
    if empty(l:yang)
        echo "No yin to this yang."
        return
    endif

    if findfile(l:yang) != '' || bufname('^'..l:yang..'$') != '' || s:tried_yang
        let s:tried_yang = v:false
        execute 'edit '..l:yang
    else
        let s:tried_yang = v:true
        echo "No yin to this yang. Try again to create."
    endif
endfunction

function buffers#pos(pos) abort
    let nums = getbufinfo({'buflisted': 1})->map({ _, b -> b.bufnr })
    if a:pos > len(nums)
        return
    endif
    execute 'buffer '..nums[a:pos - 1]
endfunction
