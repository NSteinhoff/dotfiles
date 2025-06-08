local did_init = false

local defaults = {
    c = "clangd",
    lua = "lua_ls",
    rust = "rust_analyzer",
    json = "jsonls",
    javascript = "ts_ls",
    typescript = "ts_ls",
    javascriptreact = "ts_ls",
    typescriptreact = "ts_ls",
}

local function init()
    if did_init then
        return
    end

    require("my.lsp")
    vim.fn["abbrev#cmdline"]("lspstart", "LspStart")
    vim.fn["abbrev#cmdline"]("lspstop", "LspStop")

    did_init = true
    vim.g.initialized_lsp = true
end

vim.api.nvim_create_user_command("Lsp", function(opts)
    if opts.bang then
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
            client:stop()
        end
    else
        init()

        local filetype = vim.bo.ft
        local name = defaults[filetype]
        if not name then
            vim.notify(("No default for filetype '%s'"):format(filetype))
            return
        end

        if not vim.lsp.config[name] then
            vim.notify(("No config with name '%s'"):format(name))
            return
        end

        vim.lsp.enable(name)
    end
end, {bang = true})

vim.fn["abbrev#cmdline"]("lsp", "Lsp")

-- Delay the initialization
vim.schedule(init)
