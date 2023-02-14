local opts = {
    omnifunc = "v:lua.vim.lsp.omnifunc",
    tagfunc = nil, -- force unset to avoid default
    formatexpr = "",
}

return {
    on_attach = function()
        for opt, val in pairs(opts) do
            vim.bo[opt] = val
        end
    end,
    on_detach = function()
        for opt, _ in pairs(opts) do
            vim.bo[opt] = nil
        end
    end,
}
