local lspconfig = require("lspconfig")

return function(config)
    local override = {
        autostart = false,
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    loadOutDirsFromCheck = true,
                },
                procMacro = {
                    enabled = true,
                }
            },
        },
    }

    lspconfig["rust_analyzer"].setup(vim.tbl_extend('keep', override, config))
end
