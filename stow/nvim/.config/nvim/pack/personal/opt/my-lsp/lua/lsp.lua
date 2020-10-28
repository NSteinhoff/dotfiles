local nvim_lsp = require('nvim_lsp')


-- LSP client configurations

nvim_lsp.tsserver.setup{}

--


local function clients()
    local results = {}
    for i,c in ipairs(vim.lsp.buf_get_clients()) do
        results[i] = c.name
    end
    return results
end

local function indicator()
    local clients = vim.lsp.buf_get_clients()
    if #clients > 0 then
        return '[LSP]'
    else
        return ''
    end
end

local function print_clients()
    for _,c in ipairs(vim.lsp.buf_get_clients()) do
        print(c.name)
    end
end

local function long_indicator()
    local names = clients()
    if #names == 0 then
        return ''
    else
        return '['..table.concat(names, ',')..']'
    end
end

return {
    indicator = indicator,
    long_indicator = long_indicator,
    print_clients = print_clients,
}
