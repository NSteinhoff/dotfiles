function status#yang()
    let alt = get(b:, 'alt', '')

    return alt != '' && findfile(alt) != '' ? ' ﭾ ' : ''
endfunction

function status#err()
    if winwidth(0) < 50|return ''|endif

    let nq = len(filter(getqflist(), 'v:val.valid == 1'))
    let nl = len(filter(getloclist(0), 'v:val.valid == 1'))

    if (!nq && !nl)|return ''|endif

    let q = nq ? nq : ''
    let l = nl ? nl : ''

    return '['..q..'|'..l..']'
endfunction

function status#comp()
    try
        let lsp = luaeval('require("my_lsp.status").'..(winwidth(0) < 100 ? 'tiny' : 'long')..'()')
    catch
        let lsp = ''
    endtry

    let compiler = get(b:, 'current_compiler', get(g:, 'current_compiler', ''))
    let compiler = !empty(compiler) ? winwidth(0) >= 100 ? ' '..compiler : '' : ''

    if empty(compiler) && empty(lsp)
        return ''
    endif

    if empty(lsp)
        return '['..compiler..']'
    endif

    if empty(compiler)
        return '['..lsp..']'
    endif

    return '['..lsp..'|'..compiler..']'
endfunction

function status#tree()
    let width = (winwidth(0) - 60) / 2
    if width < 40|return ''|endif
    let opts = {
        \   'indicator_size': width,
        \   'separator': '  ',
        \}
    try
        let pos = nvim_treesitter#statusline(opts)
    catch
        let pos = ''
    endtry
    return empty(pos) || pos ==? 'null' ? '' : ' '..pos
endfunction

function status#spell()
    return &spell ? '[spell]' : ''
endfunction

function status#alt()
    let alt = expand('#:t')
    if empty(alt) || expand('#') == expand('%')
        return ''
    endif
    return '  '..alt
endfunction

function status#term()
    let terminals = filter(getbufinfo(), { k, v -> v.name =~ '^term' })
    return empty(terminals) ? '' : '[>_'..len(terminals)..']'
endfunction
