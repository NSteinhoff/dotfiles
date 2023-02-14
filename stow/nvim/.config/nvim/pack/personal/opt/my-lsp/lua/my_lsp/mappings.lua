local M = {}

local opts = { buffer = true, silent = true }
local maps = {
    ["i"] = {
        ["<c-space>"] = "<c-x><c-o>",
        ["<c-h>"] = vim.lsp.buf.signature_help,
    },
    ["n"] = {
        -- ["<s-k>"] = vim.lsp.buf.hover,
        ["<c-space>"] = vim.lsp.buf.hover,
        -- Jumps
        ["gd"] = vim.lsp.buf.definition,
        ["gD"] = vim.lsp.buf.declaration,
        ["gi"] = vim.lsp.buf.implementation,
        ["gy"] = vim.lsp.buf.type_definition,
        -- Lists
        ["glr"] = vim.lsp.buf.references,
        ["gld"] = vim.lsp.buf.document_symbol,
        ["glw"] = vim.lsp.buf.workspace_symbol,
        ["gli"] = vim.lsp.buf.incoming_calls,
        ["glo"] = vim.lsp.buf.outgoing_calls,
        -- Diagnostics
        ["dh"] = vim.diagnostic.open_float,
        ["dH"] = vim.diagnostic.setloclist,
        ["]e"] = vim.diagnostic.goto_next,
        ["[e"] = vim.diagnostic.goto_prev,
        -- Code actions
        ["gA"] = vim.lsp.buf.code_action,
        ["gR"] = vim.lsp.buf.rename,
        -- ["<>"] = vim.lsp.buf.formatting_sync,
    },
}

function M.setup()
    -- vim.cmd([[nnoremap <leader>LSP    <cmd>LspStart<cr>]])
    -- vim.cmd([[nnoremap <leader>!LSP    <cmd>LspDetach<cr>]])
end

function M.on_attach(client)
    for mode, map in pairs(maps) do
        for lhs, rhs in pairs(map) do
            vim.keymap.set(mode, lhs, rhs, opts)
        end
    end
end

function M.on_detach()
    for mode, map in pairs(maps) do
        for lhs, _ in pairs(map) do
            vim.keymap.del(mode, lhs, opts)
        end
    end
end

return M
