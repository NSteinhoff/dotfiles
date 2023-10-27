local lspconfig = require("lspconfig")

return function(config)
    config.settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enabled = true,
            },
        },
    }

    lspconfig["rust_analyzer"].setup(config)
end
