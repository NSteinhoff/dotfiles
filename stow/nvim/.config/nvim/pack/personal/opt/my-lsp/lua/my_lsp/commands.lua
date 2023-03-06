local M = {}

local cmds = {
    ["LspCodeAction"] = vim.lsp.buf.code_action,
    ["LspCodeRename"] = vim.lsp.buf.rename,
    ["LspCodeFormat"] = vim.lsp.buf.format,
    ["LspListReferences"] = vim.lsp.buf.references,
    ["LspListDocumentSymbols"] = vim.lsp.buf.document_symbol,
    ["LspListWorkspaceSymbols"] = vim.lsp.buf.workspace_symbol,
    ["LspListOutgoingCalls"] = vim.lsp.buf.outgoing_calls,
    ["LspListIncomingCalls"] = vim.lsp.buf.incoming_calls,
    ["LspSetLocList"] = vim.diagnostic.setloclist,
    ["LspSetQfList"] = vim.diagnostic.setqflist,
    ["LspBufDisableDiagnostics"] = vim.diagnostic.hide,
    ["LspBufEnableDiagnostics"] = vim.diagnostic.show,
    ["LspBufStop"] = function()
        for _, client in pairs(vim.lsp.buf_get_clients(0)) do
            client.stop()
        end
    end,
    ["LspBufClients"] = function()
        for _, client in pairs(vim.lsp.buf_get_clients(0)) do
            print("--- " .. client.name .. " ---")
            print(vim.inspect(client))
            print("---")
        end
    end,
}

function M.on_attach(client)
    for name, cmd in pairs(cmds) do
        vim.api.nvim_buf_create_user_command(0, name, cmd, {})
    end
end

function M.on_detach(buf)
    for name, _ in pairs(cmds) do
        vim.api.nvim_buf_del_user_command(buf, name)
    end
end

return M
