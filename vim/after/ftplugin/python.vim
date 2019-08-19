set define=^\\s*\\(def\\\|class\\)

function! s:src_or_root(root)
    let src = finddir('src', a:root . '/**')
    if src != ""
        return l:src
    else
        return a:root
    endif
endfunction

let s:projects = map(findfile('setup.py', '**', -1), {key, val -> fnamemodify(val, ":h")})
let s:sources = map(s:projects, {key, val -> s:src_or_root(val)})
let &l:path .= ',' . join(s:sources, ',')
