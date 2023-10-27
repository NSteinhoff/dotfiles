local lspconfig = require("lspconfig")

return function(config)
    config.autostart = true;

    lspconfig["clangd"].setup(config)
end
