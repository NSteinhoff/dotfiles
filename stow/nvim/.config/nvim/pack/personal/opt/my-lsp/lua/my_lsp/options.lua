local function on_attach()
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

local function on_detach()
    vim.bo.omnifunc = ""
end

return {
    on_attach = on_attach,
    on_detach = on_detach,
}
