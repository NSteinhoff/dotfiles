local function on_attach(client)
    vim.cmd([[command! -buffer LspClients lua require("my_lsp.util").print_clients()]])
    vim.cmd([[command! -buffer LspClientSettings lua require("my_lsp.util").client_settings()]])
    vim.cmd([[command! -buffer LspClientInfo lua require("my_lsp.util").client_info()]])

    -- All Clients
    vim.cmd([[command! -buffer LspInspectClients lua require("my_lsp.util").inspect_clients()]])
    vim.cmd([[command! -buffer LspStopClients lua require("my_lsp.util").stop_clients()]])

    -- Workspace Folders
    vim.cmd([[command! -buffer LspShowWorkspace lua require("my_lsp.util").inspect_workspace_folders()]])
    vim.cmd([[command! -buffer -nargs=? -complete=dir LspAddWorkspaceFolder execute 'lua require("my_lsp.util").add_workspace_folder("<args>")']])
    vim.cmd([[command! -buffer -nargs=? -complete=dir LspRemoveWorkspaceFolder execute 'lua require("my_lsp.util").remove_workspace_folder("<args>")']])

    -- Code actions
    vim.cmd([[command! -buffer LspCodeAction lua vim.lsp.buf.code_action()]])
    vim.cmd([[command! -buffer LspCodeRename lua vim.lsp.buf.rename()]])
    vim.cmd([[command! -buffer LspCodeFormat lua vim.lsp.buf.formatting()]])

    -- Listings
    vim.cmd([[command! -buffer LspReferences lua vim.lsp.buf.references()]])
    vim.cmd([[command! -buffer LspDocumentSymbols lua vim.lsp.buf.document_symbol()]])
    vim.cmd([[command! -buffer LspWorkspaceSymbols lua vim.lsp.buf.workspace_symbol()]])

    -- Diagnostics
    vim.cmd([[command! -buffer LspDiagnostics lua require("my_lsp.util").diagnostics.print_all()]])
    vim.cmd([[command! -buffer LspDiagnosticsLine lua require("my_lsp.util").diagnostics.print_line()]])
    vim.cmd([[command! -buffer LspDiagnosticsBuffer lua require("my_lsp.util").diagnostics.print_buffer()]])
    vim.cmd([[command! -buffer LspDiagnosticsQuickfix lua require("my_lsp.util").diagnostics.set_qf()]])
end

return {
    on_attach = on_attach,
}
