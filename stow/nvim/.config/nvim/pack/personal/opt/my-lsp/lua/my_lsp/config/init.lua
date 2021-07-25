vim.cmd("packadd nvim-lspconfig")
local lspconfig = require("lspconfig")

-- Call the standard lspconfig setup function
local default = {
    __index = function(_, server)
        return function(config)
            local override = {
                -- Deactivate formatting for all servers by default
                -- Servers with custom on_attach use the default value
                -- and must deactivate formatting themselves if required.
                on_attach = function(client, ...)
                    client.resolved_capabilities.document_formatting = false

                    config.on_attach(client, ...)
                end,
            }

            lspconfig[server].setup(vim.tbl_extend("keep", override, config))
        end
    end,
}

local custom = {
    tsserver = require("my_lsp.config.tsserver"),
    rust_analyzer = require("my_lsp.config.rust_analyzer"),
    sumneko_lua = require("my_lsp.config.sumneko_lua"),
    ["null-ls"] = require("my_lsp.config.null_ls"),
}

return setmetatable(custom, default)
