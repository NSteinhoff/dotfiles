local M = {}

function M.on_attach()
    vim.cmd('packadd completion-nvim')

    require'completion'.on_attach()

    vim.g.completion_auto_change_source = 0
    vim.g.completion_enable_auto_popup = 0
    vim.g.completion_chain_complete_list = {
        default = {
            comment = {},
            string = {},
            default = {
                {complete_items = {'lsp'}},
            }
        }
    }

    vim.cmd('imap <buffer> <c-space> <Plug>(completion_trigger)')
    vim.cmd('imap <buffer> <c-j> <Plug>(completion_next_source)')
    vim.cmd('set completeopt=menuone')

    mode = 'code'
    if mode == 'smarttab' then
        vim.g.completion_enable_auto_popup = 1
        vim.cmd('set completeopt=menuone,noinsert,noselect')
        vim.cmd('imap <buffer> <expr> <Tab>   pumvisible() ? "<C-n>" : "<Plug>(completion_smart_tab)"')
        vim.cmd('imap <buffer> <expr> <S-Tab> pumvisible() ? "<C-p>" : "<Plug>(completion_smart_s_tab)"')
    elseif mode == 'code' then
        vim.g.completion_enable_auto_popup = 1
        vim.cmd('set completeopt=menuone,noinsert')
        vim.cmd('inoremap <buffer> <expr> <Tab> pumvisible() ? "<C-y>" : "<Tab>"')
    end
end

return M
