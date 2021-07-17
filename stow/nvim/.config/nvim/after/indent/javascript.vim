setlocal shiftwidth=2
setlocal formatexpr&

function s:fakename()
    let ext = {
    \ 'javascript': 'tmp.js',
    \ 'typescript': 'tmp.ts',
    \ 'javascriptreact': 'tmp.jsx',
    \ 'typescriptreact': 'tmp.tsx',
    \ 'json': 'tmp.json',
    \}
    return get(ext, &ft, 'tmp.js')
endfunction

if executable('npx')
    setlocal formatexpr=

    let filepath = (empty(expand('%')) ? s:fakename() : expand('%'))
    let prettier = 'prettier'
    let prettier.= ' --stdin-filepath '..filepath
    let prettier.= ' --config-precedence=prefer-file'
    let prettier.= ' --tab-width='..&sw

    let &l:formatprg = 'npx '..prettier
endif
