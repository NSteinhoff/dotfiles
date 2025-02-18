local M = {}

local verbose = false

local commands = {
    ["LspCodeAction"] = {
        cmd = function() vim.lsp.buf.code_action() end,
        opts = { desc = "LSP Code Action" },
    },
    ["LspCodeRename"] = {
        cmd = function() vim.lsp.buf.rename() end,
        opts = { desc = "LSP Rename Symbol" },
    },
    ["LspCodeFormat"] = {
        cmd = function() vim.lsp.buf.format() end,
        opts = { desc = "LSP Format Document" },
    },
    ["LspListReferences"] = {
        cmd = function() vim.lsp.buf.references() end,
        opts = { desc = "LSP List References" },
    },
    ["LspListDocumentSymbols"] = {
        cmd = function() vim.lsp.buf.document_symbol() end,
        opts = { desc = "LSP List Document Symbols" },
    },
    ["LspListWorkspaceSymbols"] = {
        cmd = function() vim.lsp.buf.workspace_symbol() end,
        opts = { desc = "LSP List Workspace Symbols" },
    },
    ["LspListOutgoingCalls"] = {
        cmd = function() vim.lsp.buf.outgoing_calls() end,
        opts = { desc = "LSP List Outgoing Calls" },
    },
    ["LspListIncomingCalls"] = {
        cmd = function() vim.lsp.buf.incoming_calls() end,
        opts = { desc = "LSP List Incoming Calls" },
    },
    ["LspSetLocList"] = {
        cmd = function() vim.diagnostic.setloclist() end,
        opts = { desc = "LSP Set Diagnostics Loclist" },
    },
    ["LspSetQfList"] = {
        cmd = function() vim.diagnostic.setqflist() end,
        opts = { desc = "LSP Set Diagnostics Quickfix list" },
    },
    ["LspBufDisableDiagnostics"] = {
        cmd = function() vim.diagnostic.hide() end,
        opts = { desc = "LSP Disable Diagnostics" },
    },
    ["LspBufEnableDiagnostics"] = {
        cmd = function() vim.diagnostic.show() end,
        opts = { desc = "LSP Enable Diagnostics" },
    },
    ["LspBufStop"] = {
        cmd = function()
            for _, client in pairs(vim.lsp.get_clients({bufnr = vim.api.nvim_get_current_buf()})) do
                client.stop()
            end
        end,
        opts = { desc = "LSP Stop clients for current buffer" },
    },
    ["LspBufClients"] = {
        cmd = function()
            for _, client in pairs(vim.lsp.get_clients()) do
                print("--- " .. client.name .. " ---")
                print(vim.inspect(client))
                print("---")
            end
        end,
        opts = { desc = "LSP List all clients" },
    },
}

function M.on_attach()
    for name, command in pairs(commands) do
        vim.api.nvim_buf_create_user_command(0, name, command.cmd, command.opts)
    end
end

function M.on_detach(buf)
    for name, _ in pairs(commands) do
        local res, err = pcall(vim.api.nvim_buf_del_user_command, buf, name)
        if not res and verbose then
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
