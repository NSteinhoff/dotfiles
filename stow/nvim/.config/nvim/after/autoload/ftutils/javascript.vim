" Find the alternative file for JS/TS
"
" Alternates between source and test files, while accounting for different
" package structure and naming conventions.
"
" some-file.{js,ts} <---> some-file.test.{js,ts}
"                         __tests__/some-file.test.{js,ts}
function ftutils#javascript#get_alt(path)
    let is_test = a:path =~ '\.test\.'..fnamemodify(a:path, ':e')..'$'

    let dir = fnamemodify(a:path, ':h')
    let tail = fnamemodify(a:path, ':t')
    let name = fnamemodify(tail, ':r'..(is_test ? ':r' : ''))
    let ext = fnamemodify(tail, ':e')

    if is_test
        if fnamemodify(dir, ':t') == '__tests__'
            let dir = fnamemodify(dir, ':h')
        endif
    else
        if finddir('__tests__', dir) != ''
            let dir = dir..'/__tests__'
        endif
    endif

    return dir..'/'..name..(is_test ? '.' : '.test.')..ext
endfunction
