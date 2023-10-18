function abbrev#cmdline(lhs, rhs, options = {})
    let l:prefix = get(a:options, 'prefix', '')
    let l:buffer = get(a:options, 'buffer', v:false)
    let l:test = printf("getcmdtype() ==# ':' && getcmdline() =~# '^%s%s'", substitute(l:prefix, "'", "''", 'g'), a:lhs)
    let l:expr = printf("? '%s' : '%s'", a:rhs, a:lhs)

    execute printf("cnoreabbrev %s <expr> %s %s %s", l:buffer ? '<buffer>' : '', a:lhs, l:test, l:expr)
endfunction
