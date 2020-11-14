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
    nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    nnoremap('<SPACE>', '<cmd>lua vim.lsp.buf.hover()<CR>')
    nnoremap('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    inoremap('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    -- Jump to symbols
    -- nnoremap('<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    nnoremap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    nnoremap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    nnoremap('gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    -- Listing symbols
    -- nnoremap('gr', '<cmd>lua require"telescope.builtin".lsp_references{}<CR>')
    -- nnoremap('gO', '<cmd>lua require"telescope.builtin".lsp_document_symbols{}<CR>')
    -- nnoremap('gW', '<cmd>lua require"telescope.builtin".lsp_workspace_symbols{}<CR>')
    nnoremap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    nnoremap('gs', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    nnoremap('gS', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

    -- Moving through errors
    nnoremap(']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    nnoremap('[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    nnoremap('gO', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

    -- Code actions, i.e. do stuff
    nnoremap('dc', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    nnoremap('dr', '<cmd>lua vim.lsp.buf.rename()<CR>')
end

local function set_commands()
    -- Inspect Client
    commander('LspClientInfo', 'lua print(vim.inspect(vim.lsp.get_active_clients()))')
    vim.cmd(':command! LspStopClients lua vim.lsp.stop_client(vim.lsp.get_active_clients())')

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
    -- vim.cmd('au CursorHold <buffer> silent lwindow')
    vim.cmd('aug END')
end

-- LSP client configurations
vim.cmd('packadd nvim-lspconfig')

local function on_attach(client)
    set_keymaps()
    set_commands()
    set_options()
    set_autocmds()
end


local nvim_lsp = require('nvim_lsp')
nvim_lsp.tsserver.setup({
    on_attach = on_attach,
})
nvim_lsp.rls.setup({
    on_attach = on_attach,
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

vim.cmd(':command! LspClients lua my_lsp.print_clients()')
