local M = {}

local commands = {
    ["LspCodeAction"] = {
        cmd = vim.lsp.buf.code_action,
        opts = { desc = "LSP Code Action" },
    },
    ["LspCodeRename"] = {
        cmd = vim.lsp.buf.rename,
        opts = { desc = "LSP Rename Symbol" },
    },
    ["LspCodeFormat"] = {
        cmd = vim.lsp.buf.format,
        opts = { desc = "LSP Format Document" },
    },
    ["LspListReferences"] = {
        cmd = vim.lsp.buf.references,
        opts = { desc = "LSP List References" },
    },
    ["LspListDocumentSymbols"] = {
        cmd = vim.lsp.buf.document_symbol,
        opts = { desc = "LSP List Document Symbols" },
    },
    ["LspListWorkspaceSymbols"] = {
        cmd = vim.lsp.buf.workspace_symbol,
        opts = { desc = "LSP List Workspace Symbols" },
    },
    ["LspListOutgoingCalls"] = {
        cmd = vim.lsp.buf.outgoing_calls,
        opts = { desc = "LSP List Outgoing Calls" },
    },
    ["LspListIncomingCalls"] = {
        cmd = vim.lsp.buf.incoming_calls,
        opts = { desc = "LSP List Incoming Calls" },
    },
    ["LspSetLocList"] = {
        cmd = vim.diagnostic.setloclist,
        opts = { desc = "LSP Set Diagnostics Loclist" },
    },
    ["LspSetQfList"] = {
        cmd = vim.diagnostic.setqflist,
        opts = { desc = "LSP Set Diagnostics Quickfix list" },
    },
    ["LspBufDisableDiagnostics"] = {
        cmd = vim.diagnostic.hide,
        opts = { desc = "LSP Disable Diagnostics" },
    },
    ["LspBufEnableDiagnostics"] = {
        cmd = vim.diagnostic.show,
        opts = { desc = "LSP Enable Diagnostics" },
    },
    ["LspBufStop"] = {
        cmd = function()
            for _, client in pairs(vim.lsp.buf_get_clients(0)) do
                client.stop()
            end
        end,
        opts = { desc = "LSP Stop clients for current buffer" },
    },
    ["LspBufClients"] = {
        cmd = function()
            for _, client in pairs(vim.lsp.buf_get_clients(0)) do
                print("--- " .. client.name .. " ---")
                print(vim.inspect(client))
                print("---")
            end
        end,
        opts = { desc = "LSP List all clients" },
    },
}

function M.on_attach(client)
    for name, command in pairs(commands) do
        vim.api.nvim_buf_create_user_command(0, name, command.cmd, command.opts)
    end
end

function M.on_detach(buf)
    for name, _ in pairs(commands) do
        local res, err = pcall(vim.api.nvim_buf_del_user_command, buf, name)
        if not res then
            vim.api.nvim_err_writeln(
                "Error deleting command "
                    .. name
                    .. " for buffer "
                    .. buf
                    .. ": "
                    .. err
            )
        end
    end
end

return M
