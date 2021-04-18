local lspconfig = require("lspconfig")

return function(config)
    local system_name
    if vim.fn.has("mac") == 1 then
        system_name = "macOS"
    elseif vim.fn.has("unix") == 1 then
        system_name = "Linux"
    elseif vim.fn.has("win32") == 1 then
        system_name = "Windows"
    else
        vim.cmd("echom 'Unsupported system for sumneko'")
        return
    end

    local sumneko_root_path = vim.fn.expand("$HOME") .. "/dev/lua-language-server"
    local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

    if vim.fn.executable(sumneko_binary) == 0 then
        vim.cmd("echom 'Sumneko Lua binary not found at " .. sumneko_binary.."'")
        return
    end

    local settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    }

    local override = {
        cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
        settings = settings,
    }

    lspconfig["sumneko_lua"].setup(vim.tbl_extend('keep', override, config))
end
