vim.cmd("packadd nvim-lspconfig")
local lspconfig = require("lspconfig")

-- Call the standard lspconfig setup function
local default = {
    __index = function(_, server)
        return function(config)
            lspconfig[server].setup(config)
        end
    end,
}

local custom = {
    tsserver = require("my_lsp.config.tsserver"),
    rust_analyzer = require("my_lsp.config.rust_analyzer"),
    sumneko_lua = require("my_lsp.config.sumneko_lua"),
}

return setmetatable(custom, default)
