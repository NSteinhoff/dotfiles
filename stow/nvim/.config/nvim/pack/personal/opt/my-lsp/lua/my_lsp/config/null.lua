vim.cmd("packadd null-ls.nvim")
vim.cmd("packadd plenary.nvim")
local null_ls = require("null-ls")

return function(config)
    local override = {
        sources = {
            -- null_ls.builtins.formatting.prettier,
            -- null_ls.builtins.formatting.stylua,
        },
    }
    null_ls.setup(vim.tbl_extend("keep", override, config))
end
