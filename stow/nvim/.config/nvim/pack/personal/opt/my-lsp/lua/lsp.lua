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
    nnoremap('gH',          '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

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
    commander('CodeAction', 'lua vim.lsp.buf.code_action()')
    commander('CodeRename', 'lua vim.lsp.buf.rename()')
    commander('CodeFormat', 'lua vim.lsp.buf.formatting()')

    -- Listings
    commander('References', 'lua vim.lsp.buf.references()')
    commander('DocumentSymbols', 'lua vim.lsp.buf.document_symbol()')
    commander('WorkspaceSymbols', 'lua vim.lsp.buf.workspace_symbol()')
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
        {text = "🛈", texthl = "LspDiagnosticsSignInformation"})
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
local servers = {'tsserver', 'rust_analyzer'}
for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
    })
end


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
