vim.cmd([[packadd nvim-schema-store]])

local lspconfig = require("lspconfig")

return function(config)
    local override = {
        autostart = false,
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true }
            },
        },
    }

    lspconfig["jsonls"].setup(vim.tbl_extend("keep", override, config))
end
