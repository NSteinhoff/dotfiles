local lspconfig = require("lspconfig")

return function(config)
    local override = {
        autostart = true,
    }

    lspconfig["gopls"].setup(vim.tbl_extend('keep', override, config))
end
