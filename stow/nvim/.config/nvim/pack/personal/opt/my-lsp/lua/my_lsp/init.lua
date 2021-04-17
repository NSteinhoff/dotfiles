vim.lsp.handlers["textDocument/publishDiagnostics"] = require("my_lsp.diagnostics").on_publish_diagnostics

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
}
for _, server in ipairs(servers) do
    require("my_lsp.config")[server](on_attach)
end
