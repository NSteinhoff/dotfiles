vim.lsp.handlers["textDocument/documentSymbol"] = function(_, _, result, _, bufnr)
    if not result or vim.tbl_isempty(result) then
        return
    end

    local items = vim.lsp.util.symbols_to_items(result, bufnr)
    vim.fn.setqflist({}, " ", {
        title = "LSP Symbols: " .. vim.fn.bufname(bufnr),
        items = items,
        quickfixtextfunc = "qf#text_only",
    })
    vim.api.nvim_command("copen")
    vim.api.nvim_command("wincmd p")
end

vim.lsp.handlers["textDocument/references"] = function(_, _, result)
    if not result then
        return
    end
    local items = vim.lsp.util.locations_to_items(result)
    local title = 'LSP References'
    local curtitle = vim.fn.getqflist({title = 1}).title
    local action = title == curtitle and 'r' or ' '
    vim.fn.setqflist({}, action, {items = items, title = title})

    vim.api.nvim_command("copen")
    vim.api.nvim_command("wincmd p")
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = require("my_lsp.diagnostics").on_publish_diagnostics

local function on_attach(...)
    require("my_lsp.diagnostics").on_attach(...)
    require("my_lsp.options").on_attach(...)
    require("my_lsp.commands").on_attach(...)
    require("my_lsp.mappings").on_attach(...)
    -- require("my_lsp.autocmds").on_attach(...)
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
    require("my_lsp.config")[server]({
        on_attach = on_attach,
        autostart = false,
    })
end
