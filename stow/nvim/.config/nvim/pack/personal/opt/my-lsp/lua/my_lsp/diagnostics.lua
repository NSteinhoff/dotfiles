local severities = {
    names = { "ERROR", "WARNING", "INFO", "HINT" },
    symbols = { "", "", "כֿ", "" },
}

local function print_line()
    local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    for i, d in ipairs(diagnostics) do
        print(i .. ". " .. d.source .. " " .. severities.names[d.severity])
        print(d.message)
    end
end

local function print_buffer()
    local diagnostics = vim.lsp.diagnostic.get()
    for i, d in ipairs(diagnostics) do
        print(i .. ". " .. "line " .. d.range.start.line .. " - " .. d.source .. " " .. severities.names[d.severity])
        print(d.message)
    end
end

local function print_all()
    local diagnostics = vim.lsp.diagnostic.get_all()
    for b, ds in pairs(diagnostics) do
        local bufname = vim.fn.bufname(b)
        print("--- " .. bufname)
        for i, d in ipairs(ds) do
            print(i .. ". " .. "line " .. d.range.start.line .. " - " .. d.source .. " " .. severities.names[d.severity])
            print(d.message)
        end
    end
end

local function set_loclist()
    local diagnostics = vim.lsp.diagnostic.get()
    local loc_items = {}
    local bufname = vim.fn.bufname()
    for _, d in ipairs(diagnostics) do
        local item = {
            bufnr = b,
            filename = bufname,
            lnum = d.range.start.line + 1,
            col = d.range.start.character + 1,
            type = severities.names[d.severity or 1],
            nr = d.code,
            text = d.message,
        }
        table.insert(loc_items, item)
    end
    local title = 'LSP Diagnostics'
    local curtitle = vim.fn.getloclist(0, {title = 1}).title
    local action = title == curtitle and 'r' or ' '
    vim.fn.setloclist(0, {}, action, {items = loc_items, title = title, quickfixtextfunc = 'qf#no_bufnames'})
end

local function set_qflist()
    local diagnostics = vim.lsp.diagnostic.get_all()
    local qf_items = {}
    for b, ds in pairs(diagnostics) do
        local bufname = vim.fn.bufname(b)
        for _, d in ipairs(ds) do
            local item = {
                bufnr = b,
                filename = bufname,
                lnum = d.range.start.line + 1,
                col = d.range.start.character + 1,
                type = severities.names[d.severity or 1],
                nr = d.code,
                text = d.message,
            }
            table.insert(qf_items, item)
        end
    end
    local title = 'LSP Diagnostics'
    local curtitle = vim.fn.getqflist({title = 1}).title
    local action = title == curtitle and 'r' or ' '
    vim.fn.setqflist({}, action, {items = qf_items, title = title, quickfixtextfunc = 'qf#no_bufnames'})
end

local function setup_signs()
    vim.fn.sign_define(
        "LspDiagnosticsSignError",
        { text = severities.symbols[1], texthl = "LspDiagnosticsSignError" }
    )
    vim.fn.sign_define(
        "LspDiagnosticsSignWarning",
        { text = severities.symbols[2], texthl = "LspDiagnosticsSignWarning" }
    )
    vim.fn.sign_define(
        "LspDiagnosticsSignInformation",
        { text = severities.symbols[3], texthl = "LspDiagnosticsSignInformation" }
    )
    vim.fn.sign_define(
        "LspDiagnosticsSignHint",
        { text = severities.symbols[4], texthl = "LspDiagnosticsSignHint" }
    )
end

local function on_attach()
    setup_signs()
end

local function on_publish_diagnostics(...)
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        underline = false,
        virtual_text = false,
        update_in_insert = false,
    })(...)
    local result, error = pcall(set_loclist)
    if error then vim.api.nvim_err_writeln(error) end
end

return {
    severities = severities,
    print_line = print_line,
    print_buffer = print_buffer,
    print_all = print_all,
    set_qflist = set_qflist,
    set_loclist = set_loclist,
    on_attach = on_attach,
    on_publish_diagnostics = on_publish_diagnostics,
}
