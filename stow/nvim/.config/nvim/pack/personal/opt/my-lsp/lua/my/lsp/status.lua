local symbol = "*"

local function clients()
    local results = {}
    for _, c in pairs(vim.lsp.get_clients({bufnr = 0})) do
        table.insert(results, c.name)
    end
    return results
end

local function tiny()
    if #clients() > 0 then
        return symbol
    else
        return ""
    end
end

local function short()
    local n = #clients()
    if n > 0 then
        return symbol .. n
    else
        return ""
    end
end

local function long()
    local names = clients()
    if #names == 0 then
        return ""
    else
        return symbol .. table.concat(names, ",")
    end
end

local function status()
    return {
        tiny = tiny(),
        short = short(),
        long = long(),
    }
end

return {
    tiny = tiny,
    short = short,
    long = long,
    status = status,
}
