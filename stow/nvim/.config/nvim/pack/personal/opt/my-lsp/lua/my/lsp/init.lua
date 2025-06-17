require("my.lsp.config")

vim.diagnostic.config({
    signs = true,
    underline = false,
    virtual_text = false,
    update_in_insert = false,
})

vim.lsp.config("*", {
    root_markers = { ".git" },
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")
vim.lsp.enable("zls")
vim.lsp.enable("gopls")

local function on_attach(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.semanticTokensProvider = nil

    require("my.lsp.options").on_attach()
    require("my.lsp.commands").on_attach()
    require("my.lsp.mappings").on_attach()

    vim.b['my.lsp.status'] = require("my.lsp.status").status()
end

local function on_detach(args)
    if not vim.api.nvim_buf_is_loaded(args.buf) then
        return
    end

    require("my.lsp.commands").on_detach(args.buf)
    require("my.lsp.mappings").on_detach(args.buf)
    require("my.lsp.options").on_detach(args.buf)
    vim.b['my.lsp.status'] = {}
end

local augroup = vim.api.nvim_create_augroup("my.lsp", { clear = true })

vim.api.nvim_create_autocmd(
    "LspAttach",
    { group = augroup, callback = on_attach }
)

vim.api.nvim_create_autocmd(
    "LspDetach",
    { group = augroup, callback = on_detach }
)

vim.api.nvim_create_autocmd(
    "LspProgress",
    { group = augroup, pattern = "*", command = "redrawstatus" }
)

--[[
vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = augroup,
    callback = function()
        vim.diagnostic.setloclist({ open = false })
    end,
})
--]]
