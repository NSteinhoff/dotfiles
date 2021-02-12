local function clients()
    local results = {}
    for _,c in pairs(vim.lsp.buf_get_clients()) do
        table.insert(results, c.name)
    end
    return results
end

local function tiny()
    if #clients() > 0 then
        return ''
    else
        return ''
    end
end

local function short()
    if #clients() > 0 then
        return ' '..#clients()
    else
        return ''
    end
end

local function long()
    local names = clients()
    if #names == 0 then
        return ''
    else
        return ' '..table.concat(names, ',')
    end
end

return {
    tiny = tiny,
    short = short,
    long = long,
}
