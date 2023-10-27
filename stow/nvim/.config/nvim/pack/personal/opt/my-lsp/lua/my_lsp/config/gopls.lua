local lspconfig = require("lspconfig")

return function(config)
    lspconfig["gopls"].setup(config)
end
