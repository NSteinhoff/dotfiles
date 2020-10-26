function! lsp#Indicator()
    try
        let lsp = luaeval('vim.inspect(vim.lsp.buf_get_clients())')
        if lsp != '{}'
            return '[LSP]'
        else
            return ''
        endif
    catch
        return ''
    endtry
endfunction

