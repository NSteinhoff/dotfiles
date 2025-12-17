vim.cmd("packadd nvim-lspconfig")
vim.cmd("packadd nvim-schema-store")

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enabled = true,
            },
        },
    },
})

vim.lsp.config("lua_ls", {
    on_init = function(client)
        client.config.settings.Lua =
            vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
            })
    end,
    settings = { Lua = {} },
})

vim.lsp.config("jsonls", {
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = { "c" },
})

vim.lsp.config("ts_ls", {
    init_options = {
        preferences = {
            disableSuggestions = true,
        },
    },
})

vim.lsp.config("zls", {
    settings = {
        zls = {
            semantic_tokens = "partial",
        },
    },
})

-- vim.lsp.config("csharp_ls", {})
