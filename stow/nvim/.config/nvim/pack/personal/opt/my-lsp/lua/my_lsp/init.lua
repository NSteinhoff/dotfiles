local handlers = require("my_lsp.handlers")
vim.lsp.handlers["textDocument/documentSymbol"] = handlers.quickfix_symbols
vim.lsp.handlers["textDocument/references"] = handlers.quickfix_references
vim.lsp.handlers["textDocument/publishDiagnostics"] = handlers.loclist_diagnostics

local function on_attach(...)
    require("my_lsp.diagnostics").on_attach(...)
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
    "sumneko_lua",
    -- "null-ls",
    "java_language_server",
}
for _, server in ipairs(servers) do
    require("my_lsp.config")[server]({
        on_attach = on_attach,
        autostart = false,
    })
end
