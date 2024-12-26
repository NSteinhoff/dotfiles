local lspconfig = require("lspconfig")

local function on_init(client)
    client.config.settings.Lua =
        vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        })
end

return function(config)
    config.autostart = true
    config.on_init = on_init
    config.settings = { Lua = {} }

    lspconfig["lua_ls"].setup(config)
end
