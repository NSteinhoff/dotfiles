" Find the alternative file for JS/TS
"
" Alternates between source and test files, while accounting for different
" package structure and naming conventions.
"
" some-file.{js,ts} <---> some-file.test.{js,ts}
"                         __tests__/some-file.test.{js,ts}
function ftutils#javascript#get_alt(path)
    let path = fnamemodify(a:path, ':p')
    let is_test = path =~ '\.test\.'..fnamemodify(path, ':e')..'$' || path =~ '__tests__'

    let dir = fnamemodify(path, ':h')
    let tail = fnamemodify(path, ':t')
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

function ftutils#javascript#use_prettier(buf)
    let buf = expand(a:buf)
    let path = (!empty(buf) && isdirectory(buf) ? buf..';$HOME,' : '')..'.;$HOME,;$HOME,'

    for f in ['.prettierrc', '.prettierrc.json', '.pretttierrc.js']
        if !empty(findfile(f, path))
            return v:true
        endif
    endfor

    return v:false
endfunction
