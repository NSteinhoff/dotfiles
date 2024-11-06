function s:ext()
    let ext = {
    \ 'html': 'html',
    \ 'javascript': 'js',
    \ 'typescript': 'ts',
    \ 'javascriptreact': 'jsx',
    \ 'typescriptreact': 'tsx',
    \ 'json': 'json',
    \ 'markdown': 'md',
    \ 'css': 'css',
    \}
    return get(ext, &ft, 'js')
endfunction

function s:create()
    let l:cmd = 'biome format --stdin-file-path=tmp.'..s:ext()
    let l:cmd.= ' --indent-style='..(&expandtab ? 'space' : 'tab')
    if &expandtab
        let l:cmd.= ' --indent-width='..&shiftwidth
    endif
    return l:cmd
endfunction

let b:formatname = 'biome'
let b:formatprgfunc = function("s:create")
