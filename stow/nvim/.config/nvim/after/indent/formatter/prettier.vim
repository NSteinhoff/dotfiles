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

if executable('npx')
    setlocal formatexpr=

    let prettier = 'npx prettier'
    let prettier.= ' --stdin-filepath '..(empty(expand('%')) ? s:fakename() : expand('%'))
    let prettier.= ' --config-precedence=prefer-file'
    let prettier.= ' --tab-width='..&sw

    let &l:formatprg = prettier
endif
