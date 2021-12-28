local lspconfig = require("lspconfig")

return function(config)
    local override = {
        autostart = false,
    }

    lspconfig["clangd"].setup(vim.tbl_extend("keep", override, config))
end
