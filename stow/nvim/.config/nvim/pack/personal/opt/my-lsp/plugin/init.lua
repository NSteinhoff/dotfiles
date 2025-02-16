local did_init = false

local function init()
    if did_init then
        return
    end

    require("my_lsp")
    vim.fn["abbrev#cmdline"]("lspstart", "LspStart")
    vim.fn["abbrev#cmdline"]("lspstop", "LspStop")

    did_init = true
    vim.g.initialized_lsp = true
end

vim.api.nvim_create_user_command("Lsp", function()
    init()
    vim.cmd("LspStart")
end, {})

vim.fn["abbrev#cmdline"]("lsp", "Lsp")

-- Delay the initialization
vim.schedule(init)
