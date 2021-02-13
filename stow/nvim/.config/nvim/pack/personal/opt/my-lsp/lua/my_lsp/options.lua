local function on_attach()
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

return {
    on_attach = on_attach,
}
