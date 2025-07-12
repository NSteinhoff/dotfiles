function s:fakename()
    let ext = {
    \ 'javascript': 'tmp.js',
    \ 'typescript': 'tmp.ts',
    \ 'javascriptreact': 'tmp.jsx',
    \ 'typescriptreact': 'tmp.tsx',
    \ 'json': 'tmp.json',
    \ 'markdown': 'tmp.md',
    \ 'html': 'tmp.html',
    \ 'svg': 'tmp.html',
    \ 'astro': 'tmp.astro',
    \}
    return get(ext, &ft, 'tmp.js')
endfunction

function s:create()
    let l:buf = expand('%')
    let l:path = (!empty(l:buf) && isdirectory(l:buf) ? l:buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
    let l:is_package = !empty(findfile('package.json', l:path))
    let l:is_pnpm = !empty(findfile('pnpm-lock.yaml', l:path))

    let l:cmd = ''
    if l:is_package && l:is_pnpm && executable('pnpm')
        let l:cmd  .= 'pnpm --silent dlx '
    elseif l:is_package && executable('npx')
        let l:cmd  .= 'npx '
    endif

    let l:cmd.= 'prettier'
    let l:cmd.= ' --stdin-filepath '..(empty(expand('%:t')) ? s:fakename() : expand('%:t'))
    let l:cmd.= ' --config-precedence=cli-override'
    let l:cmd.= ' --arrow-parens=always'
    let l:cmd.= ' --trailing-comma=all'
    if &expandtab
        let l:cmd.= ' --tab-width='..&shiftwidth
    else
        let l:cmd.= ' --use-tabs'
    endif

    return l:cmd
endfunction

let b:formatname = 'prettier'
let b:formatprgfunc = function("s:create")
