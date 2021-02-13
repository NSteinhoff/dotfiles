local function clients()
    local results = {}
    for _, c in pairs(vim.lsp.buf_get_clients()) do
        table.insert(results, c.name)
    end
    return results
end

local function client_info()
    local results = {}
    for _, c in pairs(vim.lsp.buf_get_clients()) do
        results[c.name] = c
    end
    return results
end

local function client_settings()
    local results = {}
    for _, c in pairs(vim.lsp.buf_get_clients()) do
        results[c.name] = c.config.settings
    end
    return results
end

local function print_clients()
    for _, c in pairs(clients()) do
        print(c)
    end
end

local function inspect(obj)
    print(vim.inspect(obj))
end

local function empty(s)
    return s == "" or s == nil
end

local function absolute(p)
    return vim.fn.fnamemodify(p, ":p")
end

local function path_or_nil(p)
    return not empty(p) and absolute(p) or nil
end

local function add_workspace_folder(dir)
    vim.lsp.buf.add_workspace_folder(path_or_nil(dir))
end

local function remove_workspace_folder(dir)
    vim.lsp.buf.remove_workspace_folder(path_or_nil(dir))
end

local function inspect_workspace_folders()
    inspect(vim.lsp.buf.list_workspace_folders())
end

local function stop_clients()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
end

local function inspect_client_info()
    inspect(client_info())
end

local function inspect_client_settings()
    inspect(client_settings())
end

local function inspect_clients()
    inspect(vim.lsp.get_active_clients())
end

return {
    print_clients = print_clients,
    add_workspace_folder,
    remove_workspace_folder,
    inspect_workspace_folders = inspect_workspace_folders,
    stop_clients = stop_clients,
    client_info = inspect_client_info,
    client_settings = inspect_client_settings,
    inspect_clients = inspect_clients,
}
