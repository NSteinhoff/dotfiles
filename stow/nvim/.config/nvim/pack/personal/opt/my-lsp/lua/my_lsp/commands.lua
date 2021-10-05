local function on_attach(client)
    -- Code actions
    vim.cmd([[command! -buffer LspCodeAction lua vim.lsp.buf.code_action()]])
    vim.cmd([[command! -buffer LspCodeRename lua vim.lsp.buf.rename()]])
    vim.cmd([[command! -buffer LspCodeFormat lua vim.lsp.buf.formatting()]])

    -- Listings
    vim.cmd([[command! -buffer LspListReferences lua vim.lsp.buf.references()]])
    vim.cmd([[command! -buffer LspListDocumentSymbols lua vim.lsp.buf.document_symbol()]])
    vim.cmd([[command! -buffer LspListWorkspaceSymbols lua vim.lsp.buf.workspace_symbol()]])

    -- Clients
    vim.cmd([[command! -buffer LspBufStop lua for _, client in pairs(vim.lsp.buf_get_clients(0)) do client.stop() end]])
    vim.cmd([[command! -buffer LspBufClients lua for _, client in pairs(vim.lsp.buf_get_clients(0)) do print("--- "..client.name.." ---") print(vim.inspect(client)) print("---") end]])
end

return {
    on_attach = on_attach,
}
