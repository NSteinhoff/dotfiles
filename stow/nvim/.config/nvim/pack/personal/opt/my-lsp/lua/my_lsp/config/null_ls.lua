vim.cmd("packadd null-ls.nvim")
vim.cmd("packadd plenary.nvim")
local null_ls = require("null-ls")
local lspconfig = require("lspconfig")

return function(config)
    local override = {
        autostart = false,
    }

    null_ls.config({
        sources = {
            -- null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.formatting.prettier,
            -- null_ls.builtins.formatting.stylua,
            -- null_ls.builtins.formatting.eslint_d,
        },
    })

    lspconfig["null-ls"].setup(vim.tbl_extend("keep", override, config))
end
