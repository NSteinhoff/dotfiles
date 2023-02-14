require("my_lsp.diagnostics").config()
require("my_lsp.mappings").setup()
require("my_lsp.3rd.fidget").setup()

local function on_attach(...)
    require("my_lsp.capabilities").on_attach(...)
    require("my_lsp.options").on_attach(...)
    require("my_lsp.commands").on_attach(...)
    require("my_lsp.mappings").on_attach(...)
end

local servers = {
    "tsserver",
    "rust_analyzer",
    "clangd",
    "jsonls",
    "cssls",
    -- "sumneko_lua",
    "java_language_server",
    "gopls",
}
for _, server in ipairs(servers) do
    require("my_lsp.config")[server]({
        on_attach = on_attach,
        autostart = false,
    })
end

vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        require("my_lsp.commands").on_detach()
        require("my_lsp.mappings").on_detach()
        require("my_lsp.options").on_detach()
    end,
})
