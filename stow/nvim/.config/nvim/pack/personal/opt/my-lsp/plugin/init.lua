local did_init = false

local function init()
    if did_init then
        return
    end

    require("my_lsp")
    vim.fn["abbrev#cmdline"]("lsp", "Lsp")
    vim.fn["abbrev#cmdline"]("lspstart", "LspStart")
    vim.fn["abbrev#cmdline"]("lspstop", "LspStop")

    did_init = true
    vim.cmd([[echom "'my-lsp' initialized"]])
end

vim.api.nvim_create_user_command("Lsp", function()
    init()
    vim.cmd("LspStart")
end, {})

-- Delay the initialization
vim.schedule(init)
