vim.cmd [[packadd nvim-lspconfig]]

local prettier = {
    formatCommand = ([[
        ./node_modules/.bin/prettier
        ${--config-precedence:configPrecedence}
        ${--tab-width:tabWidth}
        ${--single-quote:singleQuote}
        ${--trailing-comma:trailingComma}
    ]]):gsub("\n", "")
}

local prettier_options = {
    tabWidth = 4,
    singleQuote = true,
    trailingComma = "all",
    configPrecedence = "prefer-file"
}

local format_options = {
    typescript = prettier_options,
    javascript = prettier_options,
    typescriptreact = prettier_options,
    javascriptreact = prettier_options,
    json = prettier_options,
    css = prettier_options,
    scss = prettier_options,
    html = prettier_options,
    yaml = prettier_options,
    markdown = prettier_options,
}

local function on_attach(client)
    vim.b.lsp_format = true
    vim.b.lsp_format_options = format_options[vim.bo.filetype] or {}

    vim.cmd [[augroup lsp-format]]
    vim.cmd [[autocmd! * <buffer>]]
    vim.cmd [[autocmd BufWritePost <buffer> lua require'format'.format()]]
    vim.cmd [[augroup END]]

    vim.cmd [[nnoremap <buffer> <> <CMD>lua require'format'.format()<CR>]]
end

-- https://github.com/mattn/efm-langserver
require'lspconfig'.efm.setup {
    on_attach = on_attach,
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            typescript = {prettier},
            javascript = {prettier},
            typescriptreact = {prettier},
            javascriptreact = {prettier},
            yaml = {prettier},
            json = {prettier},
            html = {prettier},
            scss = {prettier},
            css = {prettier},
            markdown = {prettier},
        }
    }
}

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.cmd [[noautocmd :update]]
        end
    end
end

local function format()
    if vim.b.lsp_format then
        vim.lsp.buf.formatting(vim.b.lsp_format_options or {})
    end
end

return {
    format = format,
}
