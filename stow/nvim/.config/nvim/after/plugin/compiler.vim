function s:compile_with(name) abort
    let l:save = get(b:, 'current_compiler', '')

    try
        execute 'compiler '..a:name
    catch /.*/
        return
    endtry

    let l:restore = empty(l:save) ? 'CompilerReset' : 'compiler '..l:save
    execute 'autocmd QuickFixCmdPost make ++once '..l:restore
    make
endfunction

command! -nargs=1 -complete=compiler MakeWith call s:compile_with(<q-args>)
command! CompilerReset unlet! b:current_compiler | set makeprg< errorformat<
