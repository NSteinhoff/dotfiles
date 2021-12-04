let s:last_compiler = 'NONE'
let s:last_args = ''

function s:compilers()
    return {
    \   'local': {
    \     'name': !empty(&l:makeprg) ? get(b:, 'current_compiler', 'NONE') : 'NONE',
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


function compiler#with(local, name='last', ...) abort
    let [compiler_save, errorformat_save] = [get(b:, 'current_compiler'), &l:errorformat]
    let name = a:name == 'last' ? s:last_compiler : a:name
    let args = a:name == 'last' ? s:last_args : join(a:000, ' ')
    if name != 'NONE'
        try
            execute 'compiler '..name
            let s:last_compiler = name
            let s:last_args = args
        catch
            echoerr v:exception
            return
        endtry
    endif
    try
        execute (a:local ? 'l' : '')..'make '..args
    finally
        if !empty(compiler_save)
            execute 'compiler '..compiler_save
        else
            setlocal makeprg&
            if exists('b:current_compiler')
                unlet b:current_compiler
            endif
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
    let description = "Compiler"
    let description.= "\n========"
    let description.= "\n"
    let description.= "\nGlobal"
    let description.= "\n\tName: "..compilers.global.name
    let description.= "\n\tMakeprg: "..compilers.global.makeprg
    let description.= "\n\tErrorformat:\n\t\t"..join(split(compilers.global.errorformat, '[^\\],'), ",\n\t\t")
    let description.= "\n\n"
    let description.= "\nLocal"
    let description.= "\n\tName: "..compilers.local.name
    let description.= "\n\tMakeprg: "..compilers.local.makeprg
    let description.= "\n\tErrorformat:\n\t\t"..join(split(compilers.local.errorformat, '[^\\],'), ",\n\t\t")

    echo description
endfunction
