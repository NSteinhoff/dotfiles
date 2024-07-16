function s:fakename()
    let ext = {
    \ 'javascript': 'tmp.js',
    \ 'typescript': 'tmp.ts',
    \ 'javascriptreact': 'tmp.jsx',
    \ 'typescriptreact': 'tmp.tsx',
    \ 'json': 'tmp.json',
    \ 'markdown': 'tmp.md',
    \}
    return get(ext, &ft, 'tmp.js')
endfunction

function s:create()
    let l:buf = expand('%')
    let l:path = (!empty(l:buf) && isdirectory(l:buf) ? l:buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
    let l:ispackage = !empty(findfile('package.json', l:path))

    let l:cmd = (l:ispackage && executable('npx') ? 'npx ' : '')
    let l:cmd.= 'prettier'
    let l:cmd.= ' --stdin-filepath '..(empty(expand('%:t')) ? s:fakename() : expand('%:t'))
    let l:cmd.= ' --config-precedence=prefer-file'
    let l:cmd.= ' --arrow-parens=always'
    let l:cmd.= ' --trailing-comma=all'
    if &expandtab
        let l:cmd.= ' --tab-width='..&shiftwidth
    else
        let l:cmd.= ' --use-tab'
    endif

    return l:cmd
endfunction

let b:formatprgfunc = function("s:create")
