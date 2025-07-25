local M = {}

local verbose = false

local default_opts = { buffer = true, silent = true }
local keymaps = {
    ["i"] = {
        ["<c-space>"] = {
            rhs = "<c-x><c-o>",
            opts = { desc = "LSP Autocomplete" },
        },
        ["<c-h>"] = {
            rhs = vim.lsp.buf.signature_help,
            opts = { desc = "LSP Signature help" },
        },
    },
    ["n"] = {
        -- ["<s-k>"]     : conflicts with 'keywordprg'
        -- ["<c-space>"] : conflicts with preview tags
        ["<c-h>"] = {
            rhs = vim.lsp.buf.hover,
            opts = { desc = "LSP Hover" },
        },
        ["gh"] = {
            rhs = vim.lsp.buf.hover,
            opts = { desc = "LSP Hover" },
        },
        -- Jumps
        ["gd"] = {
            rhs = vim.lsp.buf.definition,
            opts = { desc = "LSP Goto Definition" },
        },
        ["gD"] = {
            rhs = vim.lsp.buf.declaration,
            opts = { desc = "LSP Goto Declaration" },
        },
        ["gI"] = {
            rhs = vim.lsp.buf.implementation,
            opts = { desc = "LSP Goto Implementation" },
        },
        ["gy"] = {
            rhs = vim.lsp.buf.type_definition,
            opts = { desc = "LSP Goto Type Definition" },
        },
        -- Lists
        ["glr"] = {
            rhs = vim.lsp.buf.references,
            opts = { desc = "LSP List References" },
        },
        ["gld"] = {
            rhs = vim.lsp.buf.document_symbol,
            opts = { desc = "LSP List Document Symbols" },
        },
        ["glw"] = {
            rhs = vim.lsp.buf.workspace_symbol,
            opts = { desc = "LSP List Workspace Symbols" },
        },
        ["gli"] = {
            rhs = vim.lsp.buf.incoming_calls,
            opts = { desc = "LSP List Incoming Calls" },
        },
        ["glo"] = {
            rhs = vim.lsp.buf.outgoing_calls,
            opts = { desc = "LSP List Outgoing Calls" },
        },
        -- Diagnostics
        ["]e"] = {
            rhs = function()
                vim.diagnostic.jump({ count = 1, float = true })
            end,
            opts = { desc = "LSP Goto Next Diagnostic" },
        },
        ["[e"] = {
            rhs = function()
                vim.diagnostic.jump({ count = -1, float = true })
            end,
            opts = { desc = "LSP Goto Previous Diagnostic" },
        },
        ["]E"] = {
            rhs = function()
                vim.diagnostic.jump({ count = math.huge, float = true, wrap = false })
            end,
            opts = { desc = "LSP Goto First Diagnostic in Buffer" },
        },
        ["[E"] = {
            rhs = function()
                vim.diagnostic.jump({ count = -math.huge, float = true, wrap = false })
            end,
            opts = { desc = "LSP Goto Last Diagnostic in Buffer" },
        },

        -- Code actions
        ["gA"] = {
            rhs = vim.lsp.buf.code_action,
            opts = { desc = "LSP Code Action" },
        },
        ["gR"] = {
            rhs = vim.lsp.buf.rename,
            opts = { desc = "LSP Rename Symbol" },
        },
        -- ["<>"] = { rhs = vim.lsp.buf.formatting_sync, opts = { desc = "LSP Format Document" }},
    },
}

function M.on_attach()
    for mode, mode_map in pairs(keymaps) do
        for lhs, mapping in pairs(mode_map) do
            local opts = vim.tbl_extend("force", default_opts, mapping.opts)
            vim.keymap.set(mode, lhs, mapping.rhs, opts)
        end
    end
end

function M.on_detach(buf)
    for mode, mode_map in pairs(keymaps) do
        for lhs, _ in pairs(mode_map) do
            local res, err = pcall(
                vim.keymap.del,
                mode,
                lhs,
                vim.tbl_extend("force", default_opts, { buffer = buf })
            )
            if not res and verbose then
                vim.api.nvim_err_writeln(
                    "Trying to delete mapping "
                        .. lhs
                        .. " for buffer "
                        .. buf
                        .. ": "
                        .. err
                )
            end
        end
    end
end

return M
