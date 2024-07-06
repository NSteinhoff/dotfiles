local function config()
    vim.diagnostic.config({
        signs = true,
        underline = false,
        virtual_text = false,
        update_in_insert = false,
    })
end

return {
    config = config,
}
