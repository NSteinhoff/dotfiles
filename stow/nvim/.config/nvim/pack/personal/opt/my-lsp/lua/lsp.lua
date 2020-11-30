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
    vim.cmd(':command! -buffer '..cmd..' '..action)
end

local function setlocal(name, value)
    vim.api.nvim_buf_set_option(0, name, value)
end

local function set_keymaps()
    -- Get help
    nnoremap('<space>', '<cmd>lua vim.lsp.buf.hover()<CR>')
    inoremap('<c-h>', '<cmd>lua vim.lsp.buf.hover()<CR>')
    nnoremap('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    inoremap('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    -- Jump to symbols
    nnoremap('<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    nnoremap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    nnoremap('gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    -- Listing symbols
    nnoremap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    nnoremap('gs', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    nnoremap('gS', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

    -- Moving through errors
    nnoremap(']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    nnoremap('[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    nnoremap('gh', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    nnoremap('gO', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

    -- Code actions, i.e. do stuff
    nnoremap('dca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    nnoremap('dcr', '<cmd>lua vim.lsp.buf.rename()<CR>')
end

local function set_commands()
    commander('LspClients', 'lua require"lsp".print_clients()')

    -- Inspect Client
    commander('LspClientInfo', 'lua print(vim.inspect(vim.lsp.get_active_clients()))')
    commander('LspStopClients', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients())')

    -- Code actions
    commander('CodeAction', 'lua vim.lsp.buf.code_action()')
    commander('CodeRename', 'lua vim.lsp.buf.rename()')

    -- Listings
    commander('References', 'lua vim.lsp.buf.references()')
    commander('DocumentSymbols', 'lua vim.lsp.buf.document_symbol()')
    commander('WorkspaceSymbols', 'lua vim.lsp.buf.workspace_symbol()')
end

local function set_options()
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
end

local function set_autocmds()
    vim.cmd('aug user-lsp')
    -- vim.cmd('au CursorHold <buffer> lua vim.lsp.buf.hover()')
    vim.cmd('aug END')
end

-- LSP client configurations
vim.cmd('packadd nvim-lspconfig')

local function on_attach(client)
    set_keymaps()
    set_commands()
    set_options()
    set_autocmds()
    require'my_completion'.on_attach()
end


local lspconfig = require('lspconfig')
local servers = {'tsserver', 'rls'}
for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
    })
end

-- Handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        underline = true,
        virtual_text = true,
        update_in_insert = false,
    }
)


-- Module

local M = {}

local function clients()
    local results = {}
    for i,c in pairs(vim.lsp.buf_get_clients()) do
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

my_lsp = {
    status = M.status,
}

return M
