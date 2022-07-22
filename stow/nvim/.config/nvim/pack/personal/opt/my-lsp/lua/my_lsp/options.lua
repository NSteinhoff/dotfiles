local function on_attach()
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    -- 'tagfunc' is now set by default. Disable that!
    if vim.bo.tagfunc == "v:lua.vim.lsp.tagfunc" then
        vim.bo.tagfunc = ""
    end
end

local function on_detach()
    vim.bo.omnifunc = ""
end

return {
    on_attach = on_attach,
    on_detach = on_detach,
}
