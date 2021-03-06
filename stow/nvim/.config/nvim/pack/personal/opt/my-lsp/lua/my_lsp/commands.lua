local function on_attach(client)
    -- Code actions
    vim.cmd([[command! -buffer LspCodeAction lua vim.lsp.buf.code_action()]])
    vim.cmd([[command! -buffer LspCodeRename lua vim.lsp.buf.rename()]])
    vim.cmd([[command! -buffer LspCodeFormat lua vim.lsp.buf.formatting()]])

    -- Listings
    vim.cmd([[command! -buffer LspListReferences lua vim.lsp.buf.references()]])
    vim.cmd([[command! -buffer LspListDocumentSymbols lua vim.lsp.buf.document_symbol()]])
    vim.cmd([[command! -buffer LspListWorkspaceSymbols lua vim.lsp.buf.workspace_symbol()]])

    -- Diagnostics
    vim.cmd([[command! -buffer LspDiagnosticsPrintAll lua require("my_lsp.diagnostics").print_all()]])
    vim.cmd([[command! -buffer LspDiagnosticsPrintLine lua require("my_lsp.diagnostics").print_line()]])
    vim.cmd([[command! -buffer LspDiagnosticsPrintBuffer lua require("my_lsp.diagnostics").print_buffer()]])
    vim.cmd([[command! -buffer LspDiagnosticsSetQuickfix lua require("my_lsp.diagnostics").set_qflist()]])
    vim.cmd([[command! -buffer LspDiagnosticsSetLoclist lua require("my_lsp.diagnostics").set_loclist()]])

    -- Clients
    vim.cmd([[command! -buffer LspBufStop lua for _, client in pairs(vim.lsp.buf_get_clients(0)) do client.stop() end]])
end

return {
    on_attach = on_attach,
}
