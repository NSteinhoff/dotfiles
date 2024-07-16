function s:ext()
    let ext = {
    \ 'html': 'html',
    \ 'javascript': 'js',
    \ 'typescript': 'ts',
    \ 'javascriptreact': 'jsx',
    \ 'typescriptreact': 'tsx',
    \ 'json': 'json',
    \ 'markdown': 'md',
    \}
    return get(ext, &ft, 'js')
endfunction

let b:fixprg = 'biome lint --stdin-file-path=tmp.'..s:ext()
