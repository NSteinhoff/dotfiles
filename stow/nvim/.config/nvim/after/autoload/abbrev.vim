function abbrev#cmdline(lhs, rhs, options = {})
    let l:buffer = get(a:options, 'buffer', v:false)
    let l:split = get(a:options, 'split', v:false)
    let l:range = get(a:options, 'range', v:false)
    let l:prefix = printf("%s%s", l:range ? '\(''<,''>\)\?' : '', l:split ? '\(\(tab\\|vert\\|split\)\s\)\?' : '')
    let l:test = printf("getcmdtype() ==# ':' && getcmdline() =~# '^%s%s'", substitute(l:prefix, "'", "''", 'g'), a:lhs)
    let l:expr = printf("? '%s' : '%s'", a:rhs, a:lhs)

    execute printf("cnoreabbrev %s <expr> %s %s %s", l:buffer ? '<buffer>' : '', a:lhs, l:test, l:expr)
endfunction
