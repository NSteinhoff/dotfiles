function _G.inspect(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end
