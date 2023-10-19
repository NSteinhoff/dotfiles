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
    lua_ls = require("my_lsp.config.lua_ls"),
    jsonls = require("my_lsp.config.jsonls"),
    java_language_server = require("my_lsp.config.java_language_server"),
    clangd = require("my_lsp.config.clangd"),
    gopls = require("my_lsp.config.gopls"),
}

return setmetatable(custom, default)
