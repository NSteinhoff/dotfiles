local lspconfig = require("lspconfig")

local function on_init(client)
    client.config.settings =
        vim.tbl_deep_extend("force", client.config.settings, {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        -- "${3rd}/luv/library",
                        -- "${3rd}/busted/library",
                    },
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    -- library = vim.api.nvim_get_runtime_file("", true)
                },
            },
        })

    client.notify(
        "workspace/didChangeConfiguration",
        { settings = client.config.settings }
    )

    return true
end

return function(config)
    local override = {
        autostart = true,
        on_init = on_init,
    }

    lspconfig["lua_ls"].setup(vim.tbl_extend("keep", override, config))
end
