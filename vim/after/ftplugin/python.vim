set define=^\\s*\\(def\\\|class\\)

function! s:src_or_root(root)
    echo a:root
    let src = finddir('src', a:root)
    if src != ""
        return l:src
    else
        return a:root
    endif
endfunction

let s:project_root = fnamemodify(findfile('setup.py', expand('%').';'), ':p:h')
let s:source_path = s:src_or_root(s:project_root)
let &l:path = ',,' . fnamemodify(s:source_path, ':.')
