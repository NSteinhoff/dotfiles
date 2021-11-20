require("my_lsp.diagnostics").config()
require("my_lsp.mappings").setup()

local function on_attach(...)
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
    -- "null-ls",
    "java_language_server",
}
for _, server in ipairs(servers) do
    require("my_lsp.config")[server]({
        on_attach = on_attach,
        autostart = false,
    })
end
