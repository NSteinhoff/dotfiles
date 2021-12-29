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

let buf = expand('%')
let path = (!empty(buf) && isdirectory(buf) ? buf..';$HOME,' : '')..'.;$HOME,;$HOME,'
let ispackage = !empty(findfile('package.json', path))

let prettier = (ispackage && executable('npx') ? 'npx ' : ' ') .. 'prettier'
let prettier.= ' --stdin-filepath '..(empty(expand('%')) ? s:fakename() : expand('%'))
let prettier.= ' --config-precedence=prefer-file'
let prettier.= ' --tab-width='..&sw

let b:formatprg = prettier
