local function nnoremap(lhs, rhs)
    local mode = 'n'
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
    vim.cmd(':command! '..cmd..' '..action)
end

local function setlocal(name, value)
    vim.api.nvim_buf_set_option(0, name, value)
end

local function set_keymaps()
    -- Get help
    nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    nnoremap('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    -- Jump to symbols
    nnoremap('<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('gd', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    nnoremap('gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    nnoremap('1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    -- Listing symbols
    nnoremap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')

    nnoremap('gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

    nnoremap('gO', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

    -- Moving through errors
    nnoremap(']g', '<cmd>NextDiagnostic<CR>')
    nnoremap('[g', '<cmd>PrevDiagnostic<CR>')
    nnoremap('[G', '<cmd>OpenDiagnostic<CR>')

    -- Code actions
    nnoremap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    nnoremap('<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>')

    -- Completion
    imap('<c-space>', '<Plug>(completion_trigger)')
end

local function set_commands()
    -- Code actions
    commander('-buffer CodeAction', 'lua vim.lsp.buf.code_action()')
    commander('-buffer CodeRename', 'lua vim.lsp.buf.rename()')

    -- Listings
    commander('-buffer References', 'lua vim.lsp.buf.references()')
    commander('-buffer DocumentSymbols', 'lua vim.lsp.buf.document_symbol()')
    commander('-buffer WorkspaceSymbols', 'lua vim.lsp.buf.workspace_symbol()')
end

local function set_options()
    setlocal('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- LSP client configurations

vim.cmd('packadd nvim-lspconfig')
vim.cmd('packadd diagnostic-nvim')
vim.cmd('packadd completion-nvim')
vim.cmd('packadd lsp-status.nvim')

local lsp_status = require('lsp-status')
lsp_status.register_progress()
vim.api.nvim_set_var('diagnostic_insert_delay', 1)


local function on_attach(client, bufnr)
    set_keymaps()
    set_commands()
    set_options()
    require('diagnostic').on_attach(client, bufnr)
    require('completion').on_attach(client, bufnr)
    require('lsp-status').on_attach(client, bufnr)
end


local nvim_lsp = require('nvim_lsp')
nvim_lsp.tsserver.setup({
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
})


-- Module

my_lsp = {}

local function clients()
    local results = {}
    for i,c in ipairs(vim.lsp.buf_get_clients()) do
        results[i] = c.name
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

function my_lsp.print_clients()
    for _,c in ipairs(vim.lsp.buf_get_clients()) do
        print(c.name)
    end
end

function my_lsp.status()
    return long_indicator()
end

commander('LspShowClients', 'lua my_lsp.print_clients()')
