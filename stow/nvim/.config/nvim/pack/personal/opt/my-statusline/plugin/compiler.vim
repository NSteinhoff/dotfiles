function s:compilers()
    return {
    \   'local': {
    \     'name': get(b:, 'current_compiler', 'NONE'),
    \     'makeprg': &l:makeprg,
    \     'errorformat': &l:errorformat,
    \   },
    \   'global': {
    \     'name': get(g:, 'current_compiler', 'NONE'),
    \     'makeprg': &g:makeprg,
    \     'errorformat': &g:errorformat,
    \   }
    \}
endfunction


function compiler#which()
    return get(b:, 'current_compiler', get(g:, 'current_compiler', 'NONE'))
endfunction


function compiler#with(name, ...)
    let [compiler_save, errorformat_save] = [get(b:, 'current_compiler'), &l:errorformat]
    try
        execute 'compiler '..a:name
        execute 'make '..join(a:000, ' ')
    finally
        if !empty(compiler_save)
            execute 'compiler '..compiler_save
        else
            setlocal makeprg&
            unlet b:current_compiler
        endif
        if !empty(errorformat_save)
            let &l:errorformat = errorformat_save
        else
            setlocal errorformat&
        endif
    endtry
endfunction


function compiler#describe()
    let compilers = s:compilers()
    echo "Compiler"
    echo "========"
    echo "\n"
    echo "Global"
    echo "\tName: "..compilers.global.name
    echo "\tMakeprg: "..compilers.global.makeprg
    echo "\tErrorformat: "..compilers.global.errorformat
    echo "\n"
    echo "Local"
    echo "\tName: "..compilers.local.name
    echo "\tMakeprg: "..compilers.local.makeprg
    echo "\tErrorformat: "..compilers.local.errorformat
endfunction
