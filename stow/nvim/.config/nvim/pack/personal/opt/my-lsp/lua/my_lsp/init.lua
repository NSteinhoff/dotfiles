require("my_lsp.diagnostics").config()
require("my_lsp.mappings").setup()

local function on_attach(...)
    require("my_lsp.capabilities").on_attach(...)
    require("my_lsp.options").on_attach()
    require("my_lsp.commands").on_attach()
    require("my_lsp.mappings").on_attach()
end

local function on_detach(args)
    require("my_lsp.commands").on_detach(args.buf)
    require("my_lsp.mappings").on_detach(args.buf)
    require("my_lsp.options").on_detach(args.buf)
end

local servers = {
    "tsserver",
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

vim.api.nvim_create_autocmd("LspDetach", {
    callback = on_detach,
})
