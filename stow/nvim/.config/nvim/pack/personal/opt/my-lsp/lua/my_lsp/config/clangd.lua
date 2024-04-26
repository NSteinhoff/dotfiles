local lspconfig = require("lspconfig")

return function(config)
    config.autostart = false
    config.filetypes = { "c" }

    lspconfig["clangd"].setup(config)
end
