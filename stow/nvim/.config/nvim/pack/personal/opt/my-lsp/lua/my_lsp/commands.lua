local M = {}

function M.on_attach(client)
    -- Code actions
    vim.cmd([[command! -buffer LspCodeAction lua vim.lsp.buf.code_action()]])
    vim.cmd([[command! -buffer LspCodeRename lua vim.lsp.buf.rename()]])
    vim.cmd([[command! -buffer LspCodeFormat lua vim.lsp.buf.formatting()]])

    -- Listings
    vim.cmd([[command! -buffer LspListReferences lua vim.lsp.buf.references()]])
    vim.cmd([[command! -buffer LspListDocumentSymbols lua vim.lsp.buf.document_symbol()]])
    vim.cmd([[command! -buffer LspListWorkspaceSymbols lua vim.lsp.buf.workspace_symbol()]])
    vim.cmd([[command! -buffer LspListOutgoingCalls lua vim.lsp.buf.outgoing_calls()]])
    vim.cmd([[command! -buffer LspListIncomingCalls lua vim.lsp.buf.incoming_calls()]])

    vim.cmd([[command! -buffer LspSetLocList lua vim.diagnostic.setloclist()]])
    vim.cmd([[command! -buffer LspSetQfList lua vim.diagnostic.setqflist()]])

    -- Diagnostics
    vim.cmd([[command! -buffer LspBufDisableDiagnostics lua vim.lsp.diagnostic.disable()]])
    vim.cmd([[command! -buffer LspBufEnableDiagnostics lua vim.lsp.diagnostic.enable()]])

    -- Clients
    vim.cmd([[command! -buffer LspBufStop lua for _, client in pairs(vim.lsp.buf_get_clients(0)) do client.stop() end]])
    vim.cmd([[command! -buffer LspBufClients lua for _, client in pairs(vim.lsp.buf_get_clients(0)) do print("--- "..client.name.." ---") print(vim.inspect(client)) print("---") end]])
    vim.cmd([[command! -buffer LspDetach lua require("my_lsp.commands").on_detach()]])
end

function M.on_detach(client)
    vim.cmd([[LspStop]])

    -- Code actions
    vim.cmd([[delcommand LspCodeAction]])
    vim.cmd([[delcommand LspCodeRename]])
    vim.cmd([[delcommand LspCodeFormat]])

    -- Listings
    vim.cmd([[delcommand LspListReferences]])
    vim.cmd([[delcommand LspListDocumentSymbols]])
    vim.cmd([[delcommand LspListWorkspaceSymbols]])
    vim.cmd([[delcommand LspListOutgoingCalls]])
    vim.cmd([[delcommand LspListIncomingCalls]])

    vim.cmd([[delcommand LspSetLocList]])
    vim.cmd([[delcommand LspSetQfList]])

    -- Diagnostics
    vim.cmd([[delcommand LspBufEnableDiagnostics]])
    vim.cmd([[delcommand LspBufDisableDiagnostics]])

    -- Clients
    vim.cmd([[delcommand LspBufStop]])
    vim.cmd([[delcommand LspBufClients]])
    vim.cmd([[delcommand LspDetach]])

    require("my_lsp.mappings").on_detach()
    require("my_lsp.options").on_detach()
end

return M
