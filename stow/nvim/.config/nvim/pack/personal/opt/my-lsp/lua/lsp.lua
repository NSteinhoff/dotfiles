vim.cmd('packadd nvim-lspconfig')
local lspconfig = require'lspconfig'

local M = {}

local severities = {
    names = {'ERROR', 'WARNING', 'INFO', 'HINT'},
    symbols = {'', '', 'כֿ', ''}
}


local function nnoremap(lhs, rhs)
    local mode = 'n'
    local current_buffer = 0
    local opts = { silent = true, noremap = true }

    vim.api.nvim_buf_set_keymap(current_buffer, mode, lhs, rhs, opts)
end

local function inoremap(lhs, rhs)
    local mode = 'i'
    local current_buffer = 0
    local opts = { silent = true, noremap = true }

    vim.api.nvim_buf_set_keymap(current_buffer, mode, lhs, rhs, opts)
end

local function imap(lhs, rhs)
    local mode = 'i'
    local current_buffer = 0
    local opts = { silent = true, noremap = false }

    vim.api.nvim_buf_set_keymap(current_buffer, mode, lhs, rhs, opts)
end

local function commander(cmd, action)
    vim.cmd('command! -buffer '..cmd..' '..action)
end

local function setlocal(name, value)
    vim.api.nvim_buf_set_option(0, name, value)
end

local function setup_keymaps(client)
    -- Completion
    inoremap('<c-space>',   '<C-X><C-O>')

    -- Get help
    nnoremap('<space>',     '<cmd>lua vim.lsp.buf.hover()<CR>')
    nnoremap('K',           '<cmd>lua vim.lsp.buf.hover()<CR>')
    inoremap('<c-h>',       '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    -- Jump to symbols
    nnoremap('<c-]>',       '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('gd',          '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('gD',          '<cmd>lua vim.lsp.buf.declaration()<CR>')
    nnoremap('gi',          '<cmd>lua vim.lsp.buf.implementation()<CR>')
    nnoremap('gy',          '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    -- Listing symbols
    nnoremap('gr',          '<cmd>lua vim.lsp.buf.references()<CR>')
    nnoremap('gw',          '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    nnoremap('gW',          '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

    -- Diagnostics
    nnoremap('gh',          '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    nnoremap('gH',          '<cmd>lua require"lsp".print_line_diagnostics()<CR>')

    --[[ Moving to errors is done via the loclist
    nnoremap(']g',          '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    nnoremap('[g',          '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    nnoremap('gO',          '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
    --]]

    -- Code actions,     i.e. do stuff
    nnoremap('dca',         '<cmd>lua vim.lsp.buf.code_action()<CR>')
    nnoremap('dcr',         '<cmd>lua vim.lsp.buf.rename()<CR>')
    nnoremap('dcf',         '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

local function setup_commands(client)
    commander('LspClients', 'lua require"lsp".print_clients()')
    commander('LspClientSettings', 'lua require"lsp".client_settings()')
    commander('LspClientInfo', 'lua require"lsp".client_info()')

    -- All Clients
    commander('LspInspectClients', 'lua require"lsp".inspect_clients()')
    commander('LspStopClients', 'lua require"lsp".stop_clients()')

    -- Workspace Folders
    commander('LspShowWorkspace', 'lua require"lsp".inspect_workspace_folders()')
    vim.cmd [[command! -buffer -nargs=? -complete=dir LspAddWorkspaceFolder execute 'lua require"lsp".add_workspace_folder("<args>")']]
    vim.cmd [[command! -buffer -nargs=? -complete=dir LspRemoveWorkspaceFolder execute 'lua require"lsp".remove_workspace_folder("<args>")']]

    -- Code actions
    commander('LspCodeAction', 'lua vim.lsp.buf.code_action()')
    commander('LspCodeRename', 'lua vim.lsp.buf.rename()')
    commander('LspCodeFormat', 'lua vim.lsp.buf.formatting()')

    -- Listings
    commander('LspReferences', 'lua vim.lsp.buf.references()')
    commander('LspDocumentSymbols', 'lua vim.lsp.buf.document_symbol()')
    commander('LspWorkspaceSymbols', 'lua vim.lsp.buf.workspace_symbol()')

    -- Diagnostics
    commander('LspDiagnostics', 'lua require"lsp".print_diagnostics()')
    commander('LspDiagnosticsLine', 'lua require"lsp".print_line_diagnostics()')
    commander('LspDiagnosticsBuffer', 'lua require"lsp".print_buffer_diagnostics()')
    commander('LspDiagnosticsQuickfix', 'lua require"lsp".set_qf_diagnostics()')
end

local function setup_options(client)
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

local function setup_signs()
    vim.fn.sign_define("LspDiagnosticsSignError",
        {text = severities.symbols[1], texthl = "LspDiagnosticsSignError"})
    vim.fn.sign_define("LspDiagnosticsSignWarning",
        {text = severities.symbols[2], texthl = "LspDiagnosticsSignWarning"})
    vim.fn.sign_define("LspDiagnosticsSignInformation",
        {text = severities.symbols[3], texthl = "LspDiagnosticsSignInformation"})
    vim.fn.sign_define("LspDiagnosticsSignHint",
        {text = severities.symbols[4], texthl = "LspDiagnosticsSignHint"})
end

local function setup_completion()
    vim.cmd('packadd my-completions')
    if client.resolved_capabilities.completion then
        require'my_completion'.on_attach(client)
    end
end

local function setup_lspsaga()
    vim.cmd('packadd lspsaga.nvim')
    local saga = require 'lspsaga'

    saga.init_lsp_saga {
        use_saga_diagnostic_handler = false,
        use_saga_diagnostic_sign = false,
        max_hover_width = vim.fn.winwidth(0) - 20,
        error_sign = severities.symbols[1],
        warn_sign  = severities.symbols[2],
        infor_sign  = severities.symbols[3],
        hint_sign  = severities.symbols[4],
    }

    nnoremap('g<c-]>',      '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>')
    nnoremap('<c-w>}',      '<cmd>lua require"lspsaga.provider".preview_definition()<CR>')

    inoremap('<c-h>',       '<cmd>lua require"lspsaga.signaturehelp".signature_help()<CR>')

    --[[
    nnoremap('dca',         '<cmd>lua require"lspsaga.codeaction".code_action()<CR>')
    nnoremap('dcr',         '<cmd>lua require"lspsaga.rename".rename()<CR>')
    --]]

    --[[
    nnoremap('gh',          '<cmd>lua require"lspsaga.diagnostic".show_line_diagnostics()<CR>')
    nnoremap('[g',          '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>')
    nnoremap(']g',          '<cmd>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>')
    --]]
end

-- LSP client configurations
local function on_attach(client)
    setup_keymaps(client)
    setup_commands(client)
    setup_options(client)
    setup_signs(client)

    --[[
    setup_completion(client)
    --]]

    --[[
    setup_lspsaga(client)
    --]]
end

local servers = {'clangd', 'jsonls', 'cssls'} for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = on_attach,
    }
end

lspconfig['tsserver'].setup {
    on_attach = on_attach,
    root_dir = function(fname)
        -- Prefer the repository root for typescript
        -- NOTE:
        -- This may break for projects that don't use project references defined
        -- in the root tsconfig.json, or when typescript is only used in a subdirectory.
        local util = require'lspconfig/util'
        local git_root = util.find_git_ancestor(fname)
        return git_root and util.path.is_file(util.path.join(git_root, "tsconfig.json"))
            and git_root
            or util.root_pattern("tsconfig.json", "package.json")(fname)
    end
}

---[[
lspconfig['rust_analyzer'].setup {
    on_attach = on_attach,
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                -- Rust Analyzer does not handle procedural macros yet.
                disabled = {'missing-unsafe'}
            }
        }
    }
}
--]]

-- Handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            signs = true,
            underline = false,
            virtual_text = false,
            update_in_insert = false,
        }
    )(...)
    pcall(vim.lsp.diagnostic.set_loclist, {open_loclist = false})
end

-- Module
local function clients()
    local results = {}
    for _,c in pairs(vim.lsp.buf_get_clients()) do
        table.insert(results, c.name)
    end
    return results
end

local function client_info()
    local results = {}
    for _,c in pairs(vim.lsp.buf_get_clients()) do
        results[c.name] = c
    end
    return results
end

local function client_settings()
    local results = {}
    for _,c in pairs(vim.lsp.buf_get_clients()) do
        results[c.name] = c.config.settings
    end
    return results
end

function M.print_clients()
    for _,c in pairs(clients()) do
        print(c)
    end
end

M.status = {
    long = function()
        local names = clients()
        if #names == 0 then
            return ''
        else
            return ' '..table.concat(names, ',')
        end
    end,
    tiny = function()
        if #clients() > 0 then
            return ''
        else
            return ''
        end
    end,
    short = function()
        if #clients() > 0 then
            return ' '..#clients()
        else
            return ''
        end
    end
}

local function inspect(obj)
    print(vim.inspect(obj))
end

local function empty(s)
    return s == '' or s == nil
end

local function absolute(p)
    return vim.fn.fnamemodify(p, ':p')
end

local function path_or_nil(p)
    return not empty(p) and absolute(p) or nil
end

function M.add_workspace_folder(dir)
    vim.lsp.buf.add_workspace_folder(path_or_nil(dir))
end

function M.remove_workspace_folder(dir)
    vim.lsp.buf.remove_workspace_folder(path_or_nil(dir))
end

function M.inspect_workspace_folders()
    inspect(vim.lsp.buf.list_workspace_folders())
end

function M.stop_clients()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
end

function M.client_info()
    inspect(client_info())
end

function M.client_settings()
    inspect(client_settings())
end

function M.inspect_clients()
    inspect(vim.lsp.get_active_clients())
end

function M.print_line_diagnostics()
    local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    for i,d in ipairs(diagnostics) do
        print(i..'. '..d.source..' '..severities.names[d.severity])
        print(d.message)
    end
end

function M.print_buffer_diagnostics()
    local diagnostics = vim.lsp.diagnostic.get()
    for i,d in ipairs(diagnostics) do
        print(i..'. '..'line '..d.range.start.line..' - '..d.source..' '..severities.names[d.severity])
        print(d.message)
    end
end

function M.print_diagnostics()
    local diagnostics = vim.lsp.diagnostic.get_all()
    for b,ds in pairs(diagnostics) do
        local bufname = vim.fn.bufname(b)
        print('--- '..bufname)
        for i,d in ipairs(ds) do
            print(i..'. '..'line '..d.range.start.line..' - '..d.source..' '..severities.names[d.severity])
            print(d.message)
        end
    end
end

function M.set_qf_diagnostics()
    local diagnostics = vim.lsp.diagnostic.get_all()
    local qf_items = {}
    for b,ds in pairs(diagnostics) do
        local bufname = vim.fn.bufname(b)
        for _,d in ipairs(ds) do
            local item = {
                bufnr = b,
                filename = bufname,
                lnum = d.range.start.line,
                col = d.range.start.character,
                type = severities.names[d.severity or 1],
                nr = d.code,
                text = d.message,
            }
            table.insert(qf_items, item)
        end
    end
    vim.fn.setqflist(qf_items)
end

lsp_status = M.status.long
lsp_shortstatus = M.status.short
lsp_tinystatus = M.status.tiny

return M
