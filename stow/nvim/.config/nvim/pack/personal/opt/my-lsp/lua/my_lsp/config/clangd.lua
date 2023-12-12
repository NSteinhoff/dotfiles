local lspconfig = require("lspconfig")

return function(config)
    config.autostart = true
    config.filetypes = { "c" }

    lspconfig["clangd"].setup(config)
end
