vim.cmd([[packadd nvim-schema-store]])

local lspconfig = require("lspconfig")

return function(config)
    config.settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    }

    lspconfig["jsonls"].setup(config)
end
