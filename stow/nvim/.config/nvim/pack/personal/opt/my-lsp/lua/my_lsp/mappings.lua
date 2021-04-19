local function on_attach(client)
    -- Completion
    vim.cmd([[inoremap <silent> <buffer> <c-space>    <C-X><C-O>]])

    -- Get help
    -- vim.cmd([[nnoremap <silent> <buffer> <space>      <cmd>lua vim.lsp.buf.hover()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> K            <cmd>lua vim.lsp.buf.hover()<CR>]])
    vim.cmd([[inoremap <silent> <buffer> <c-h>        <cmd>lua vim.lsp.buf.signature_help()<CR>]])

    -- Jump to symbols
    vim.cmd([[nnoremap <silent> <buffer> gd           <cmd>lua vim.lsp.buf.definition()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gD           <cmd>lua vim.lsp.buf.declaration()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gi           <cmd>lua vim.lsp.buf.implementation()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gy           <cmd>lua vim.lsp.buf.type_definition()<CR>]])

    -- Listing symbols
    vim.cmd([[nnoremap <silent> <buffer> gr           mZ<cmd>lua vim.lsp.buf.references()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gw           mZ<cmd>lua vim.lsp.buf.workspace_symbol()<CR>]])

    -- Diagnostics
    vim.cmd([[nnoremap <silent> <buffer> gh           <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gH           <cmd>lua require"my_lsp.diagnostics".print_line()<CR>]])

    -- Code actions,     i.e. (d)o (c)ode (a)ction
    vim.cmd([[nnoremap <silent> <buffer> dca          <cmd>lua vim.lsp.buf.code_action()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> dcr          <cmd>lua vim.lsp.buf.rename()<CR>]])

    if client.resolved_capabilities.document_formatting then
        vim.cmd([[nnoremap <silent> <buffer> dcf          <cmd>lua vim.lsp.buf.formatting()<CR>]])
    end
end

return {
    on_attach = on_attach,
}
