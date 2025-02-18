require("my_lsp.diagnostics").config()
require("my_lsp.mappings").setup()

local function on_attach(...)
    require("my_lsp.capabilities").on_attach(...)
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

local servers = {
    "ts_ls",
    "rust_analyzer",
    "clangd",
    "jsonls",
    "cssls",
    "lua_ls",
    "java_language_server",
    "gopls",
    "pylsp",
    "html",
}

for _, server in ipairs(servers) do
    require("my_lsp.config")[server]({
        on_attach = on_attach,
        autostart = false,
    })
end

local augroup = vim.api.nvim_create_augroup("my-lsp", { clear = true })

vim.api.nvim_create_autocmd("LspDetach", {
    group = augroup,
    callback = on_detach,
})

--[[
vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = augroup,
    callback = function()
        vim.diagnostic.setloclist({ open = false })
    end,
})
--]]
