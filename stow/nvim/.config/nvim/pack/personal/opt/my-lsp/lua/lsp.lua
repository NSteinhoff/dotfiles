local M = {}

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

local function setup_keymaps()
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

    -- Moving through errors
    nnoremap(']g',          '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    nnoremap('[g',          '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    nnoremap('gh',          '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    nnoremap('gH',          '<cmd>lua require"lsp".print_line_diagnostics()<CR>')
    nnoremap('gO',          '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

    -- Code actions,     i.e. do stuff
    nnoremap('dca',         '<cmd>lua vim.lsp.buf.code_action()<CR>')
    nnoremap('dcr',         '<cmd>lua vim.lsp.buf.rename()<CR>')
    nnoremap('dcf',         '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

local function setup_commands()
    commander('LspClients', 'lua require"lsp".print_clients()')

    -- Inspect Client
    commander('LspClientInfo', 'lua print(vim.inspect(vim.lsp.get_active_clients()))')
    commander('LspStopClients', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients())')

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

local function setup_options()
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

local function setup_autocmds()
    vim.cmd('augroup user-lsp')
    vim.cmd('autocmd!')
    -- vim.cmd('autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ show_header = false })')
    vim.cmd('augroup END')
end

local function setup_signs()
    vim.fn.sign_define("LspDiagnosticsSignError",
        {text = "", texthl = "LspDiagnosticsSignError"})
    vim.fn.sign_define("LspDiagnosticsSignWarning",
        {text = "", texthl = "LspDiagnosticsSignWarning"})
    vim.fn.sign_define("LspDiagnosticsSignInformation",
        {text = "i", texthl = "LspDiagnosticsSignInformation"})
    vim.fn.sign_define("LspDiagnosticsSignHint",
        {text = "!", texthl = "LspDiagnosticsSignHint"})
end

-- LSP client configurations
vim.cmd('packadd nvim-lspconfig')
-- vim.cmd('packadd my-completions')

local function on_attach(client)
    setup_keymaps()
    setup_commands()
    setup_options()
    setup_autocmds()
    setup_signs()
    -- require'my_completion'.on_attach()
    print('LSP: ' .. client.name .. ' attached.')
end


local lspconfig = require('lspconfig')
local servers = {'tsserver', 'rust_analyzer', 'clangd'}
for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = on_attach,
    }
end

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                enable = true,
                globals = { "vim" },
            },
        }
    },
}


-- Handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        underline = false,
        virtual_text = true,
        update_in_insert = false,
    }
)


-- Module
local function clients()
    local results = {}
    for _,c in pairs(vim.lsp.buf_get_clients()) do
        table.insert(results, c.name)
    end
    return results
end

local function indicator()
    if #clients() > 0 then
        return '[LSP]'
    else
        return ''
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

function M.print_clients()
    for _,c in pairs(clients()) do
        print(c)
    end
end

function M.status()
    return long_indicator()
end

local severities = {
    [1] = 'ERROR',
    [2] = 'WARNING',
    [3] = 'INFO',
    [4] = 'HINT',
}

function M.print_line_diagnostics()
    local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    for i,d in ipairs(diagnostics) do
        print(i..'. '..d.source..' '..severities[d.severity])
        print(d.message)
    end
end

function M.print_buffer_diagnostics()
    local diagnostics = vim.lsp.diagnostic.get()
    for i,d in ipairs(diagnostics) do
        print(i..'. '..'line '..d.range.start.line..' - '..d.source..' '..severities[d.severity])
        print(d.message)
    end
end

function M.print_diagnostics()
    local diagnostics = vim.lsp.diagnostic.get_all()
    for b,ds in pairs(diagnostics) do
        local bufname = vim.fn.bufname(b)
        print('--- '..bufname)
        for i,d in ipairs(ds) do
            print(i..'. '..'line '..d.range.start.line..' - '..d.source..' '..severities[d.severity])
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
                type = severities[d.severity or 1],
                nr = d.code,
                text = d.message,
            }
            table.insert(qf_items, item)
        end
    end
    vim.fn.setqflist(qf_items)
end

My_lsp = {
    status = M.status,
}

return M
