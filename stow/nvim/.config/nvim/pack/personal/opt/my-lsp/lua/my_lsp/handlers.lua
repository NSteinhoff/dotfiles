local M = {}

function M.quickfix_symbols(_, _, result, _, bufnr)
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

function M.quickfix_references(_, _, result)
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

M.loclist_diagnostics = require("my_lsp.diagnostics").on_publish_diagnostics

return M
