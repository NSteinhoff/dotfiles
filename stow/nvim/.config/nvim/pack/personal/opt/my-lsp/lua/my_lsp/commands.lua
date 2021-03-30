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
    vim.cmd([[command! -buffer LspDiagnostics lua require("my_lsp.util").diagnostics.print_all()]])
    vim.cmd([[command! -buffer LspDiagnosticsLine lua require("my_lsp.util").diagnostics.print_line()]])
    vim.cmd([[command! -buffer LspDiagnosticsBuffer lua require("my_lsp.util").diagnostics.print_buffer()]])
    vim.cmd([[command! -buffer LspDiagnosticsQuickfix lua require("my_lsp.util").diagnostics.set_qf()]])
end

return {
    on_attach = on_attach,
}
