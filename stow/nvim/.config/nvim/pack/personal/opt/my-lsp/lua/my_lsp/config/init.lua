vim.cmd("packadd nvim-lspconfig")
local lspconfig = require("lspconfig")

-- Call the standard lspconfig setup function
local default = {
    __index = function(_, server)
        return function(on_attach)
            lspconfig[server].setup({ on_attach = on_attach })
        end
    end,
}

local custom = {
    tsserver = require("my_lsp.config.tsserver"),
    rust_analyzer = require("my_lsp.config.rust_analyzer"),
}

return setmetatable(custom, default)
