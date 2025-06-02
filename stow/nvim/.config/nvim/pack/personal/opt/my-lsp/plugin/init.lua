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

-- Delay the initialization
vim.schedule(init)
