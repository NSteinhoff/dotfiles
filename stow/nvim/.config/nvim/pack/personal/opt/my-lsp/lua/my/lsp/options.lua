local opts = {
    omnifunc = "v:lua.vim.lsp.omnifunc",
    tagfunc = "<",
    formatexpr = "<",
}

return {
    on_attach = function()
        for opt, val in pairs(opts) do
            if val == "<" then
                vim.cmd("setlocal " .. opt .. "<")
            else
                vim.bo[opt] = val
            end
        end
    end,
    on_detach = function(buf)
        for opt, _ in pairs(opts) do
            vim.bo[buf][opt] = nil
        end
    end,
}
