local M = {}

function M.setup()
    vim.cmd [[packadd fidget.nvim]]
    require"fidget".setup{}
end

return M
