local lspconfig = require("lspconfig")

local schemas = {
    { "package", { "package.json" } },
    { "prettierrc", { ".prettierrc.json" } },
    { "tsconfig", { "tsconfig.json", "tsconfig.settings.json" } },
}

local function get_schemas()
    local res = {}
    for _, schema in ipairs(schemas) do
        table.insert(res, {
            fileMatch = schema[2],
            url = "https://json.schemastore.org/".. schema[1]
        })
    end
    return res
end

return function(config)
    local override = {
        autostart = false,
        settings = {
            json = {
                schemas = get_schemas(),
            },
        },
    }

    lspconfig["jsonls"].setup(vim.tbl_extend("keep", override, config))
end
