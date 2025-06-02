require("my_lsp.config")

vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("jsonls")
-- vim.lsp.enable("clangd")
-- vim.lsp.enable("rust_analyzer")

vim.diagnostic.config({
    signs = true,
    underline = false,
    virtual_text = false,
    update_in_insert = false,
})

local function on_attach(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.semanticTokensProvider = nil

    require("my_lsp.options").on_attach()
    require("my_lsp.commands").on_attach()
    require("my_lsp.mappings").on_attach()

    vim.b.my_lsp_status = require("my_lsp.status").status()
end

local function on_detach(args)
    if not vim.api.nvim_buf_is_loaded(args.buf) then
        return
    end

    require("my_lsp.commands").on_detach(args.buf)
    require("my_lsp.mappings").on_detach(args.buf)
    require("my_lsp.options").on_detach(args.buf)
    vim.b.my_lsp_status = {}
end

local augroup = vim.api.nvim_create_augroup("my-lsp", { clear = true })

vim.api.nvim_create_autocmd(
    "LspAttach",
    { group = augroup, callback = on_attach }
)

vim.api.nvim_create_autocmd(
    "LspDetach",
    { group = augroup, callback = on_detach }
)

--[[
vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = augroup,
    callback = function()
        vim.diagnostic.setloclist({ open = false })
    end,
})
--]]
