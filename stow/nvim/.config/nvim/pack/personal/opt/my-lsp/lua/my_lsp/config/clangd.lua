local lspconfig = require("lspconfig")

return function(config)
    config.cmd = { "clangd", "--log=verbose" }
    config.autostart = false
    config.filetypes = { "c" }

    lspconfig["clangd"].setup(config)
end
