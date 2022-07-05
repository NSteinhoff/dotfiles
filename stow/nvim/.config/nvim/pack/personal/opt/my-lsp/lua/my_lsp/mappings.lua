local M = {}

function M.setup()
    -- vim.cmd([[nnoremap <leader>LSP    <cmd>LspStart<cr>]])
    -- vim.cmd([[nnoremap <leader>!LSP    <cmd>LspDetach<cr>]])
end

function M.on_attach(client)
    -- Completion
    vim.cmd([[inoremap <silent> <buffer> <c-space>    <C-X><C-O>]])

    -- Get help
    vim.cmd([[nnoremap <silent> <buffer> <c-space>    <cmd>lua vim.lsp.buf.hover()<CR>]])
    vim.cmd([[inoremap <silent> <buffer> <c-h>        <cmd>lua vim.lsp.buf.signature_help()<CR>]])

    -- Jump to symbols
    vim.cmd([[nnoremap <silent> <buffer> gd           <cmd>lua vim.lsp.buf.definition()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gD           <cmd>lua vim.lsp.buf.declaration()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gi           <cmd>lua vim.lsp.buf.implementation()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gy           <cmd>lua vim.lsp.buf.type_definition()<CR>]])

    -- Listing symbols
    vim.cmd([[nnoremap <silent> <buffer> gr           mZ<cmd>lua vim.lsp.buf.references()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gw           mZ<cmd>lua vim.lsp.buf.document_symbol()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gW           mZ<cmd>lua vim.lsp.buf.workspace_symbol()<CR>]])

    -- Diagnostics
    vim.cmd([[nnoremap <silent> <buffer> dh           <cmd>lua vim.diagnostic.open_float()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> dH           <cmd>lua vim.diagnostic.setloclist()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> ]e           <cmd>lua vim.diagnostic.goto_next()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> [e           <cmd>lua vim.diagnostic.goto_prev()<CR>]])

    -- Code actions,     i.e. (d)o (c)ode [(a)ction | (r)ename | (f)ormat]
    vim.cmd([[nnoremap <silent> <buffer> gA          <cmd>lua vim.lsp.buf.code_action()<CR>]])
    vim.cmd([[nnoremap <silent> <buffer> gR          <cmd>lua vim.lsp.buf.rename()<CR>]])

    -- Overwrite the standard 'formatprg' based formatting
    -- vim.cmd([[nnoremap <silent> <buffer> <>           <cmd>lua vim.lsp.buf.formatting_sync()<CR>]])
end

function M.on_detach()
    -- Completion
    vim.cmd([[iunmap <buffer> <c-space>]])

    -- Get help
    vim.cmd([[nunmap <buffer> <c-space>]])
    vim.cmd([[iunmap <buffer> <c-h>]])

    -- Jump to symbols
    vim.cmd([[nunmap <buffer> gd]])
    vim.cmd([[nunmap <buffer> gD]])
    vim.cmd([[nunmap <buffer> gi]])
    vim.cmd([[nunmap <buffer> gy]])

    -- Listing symbols
    vim.cmd([[nunmap <buffer> gr]])
    vim.cmd([[nunmap <buffer> gw]])
    vim.cmd([[nunmap <buffer> gW]])

    -- Diagnostics
    vim.cmd([[nunmap <buffer> dh]])
    vim.cmd([[nunmap <buffer> dH]])
    vim.cmd([[nunmap <buffer> ]e]])
    vim.cmd([[nunmap <buffer> [e]])

    -- Code actions,     i.e. (d)o (c)ode (a)ction
    vim.cmd([[nunmap <buffer> gA]])
    vim.cmd([[nunmap <buffer> gR]])
end

return M
